library(shiny)
library(shinydashboard)
library(DT)
library(dplyr)

source("PriorityTable.R")
source("ppk.R")

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Hospital Wait Time Quality Control", titleWidth = 400),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    h2("", style = "color: #007BFF; text-align: center;"),
    
    # First row: Two columns
    fluidRow(
      # First column (left): Widgets and Patient Overview Table
      column(8, 
        # First row (inside the first column): Widgets (Dropdown, Legend, High-Risk Count)
        fluidRow(
          column(4,  # Left side: Dropdown menu
            box(
              title = "Display Options",
              width = NULL,
              solidHeader = TRUE,
              status = "primary",
              selectInput(
                inputId = "sort_choice",
                label = "Sort by:",
                choices = c("Injury Severity Score", "Hours Since Last Checked", "Priority Score"),
                selected = "Wait Time",
                width = "100%"
              )
            )
          ),
          column(4,  # Middle: Priority Score Color Legend
            box(
              title = "Priority Score Color Legend",
              width = NULL,
              solidHeader = TRUE,
              status = "info",
              uiOutput("color_legend")
            )
          ),
          column(4,  # Right side: High-Risk Patient Count
            box(
              width = NULL,
              valueBoxOutput("high_risk_count_box", width = 12)  # Warning box for high-risk patients
            )
          )
        ),
        
        # Second row (inside the first column): Patient Overview Table
        fluidRow(
          column(12,  # Full-width: Patient Table
            box(
              title = "Patient Priority Table",
              width = NULL,
              solidHeader = TRUE,
              status = "primary",
              DTOutput("patient_table")
            )
          )
        )
      ),
      
      # Second column (right): SPC charts and PPK value boxes
      column(4, 
        # First row (inside the second column): SPC chart
        fluidRow(
          column(12,  # Full-width: First SPC chart
            box(
              title = "Statistical Process Control (SPC) Chart",
              width = NULL,
              solidHeader = TRUE,
              status = "primary",
              plotOutput("spc_chart", height = "300px")  # Display SPC chart with appropriate height
            )
          )
        ),
        
        # Second row (inside the second column): Two PPK value boxes side by side
        fluidRow(
          column(6,  # Left side: Current PPK value
            valueBoxOutput("ppk_box", width = 12)  # Current PPK
          ),
          column(6,  # Right side: Predicted PPK value
            valueBoxOutput("predicted_ppk_box", width = 12)  # Predicted PPK
          )
        )
      )
    )
  )
)


# Server logic
server <- function(input, output) {
  # Compute PPK values by calling the ppk function
  ppk_set <- reactive({
    # Update to current system time
    current_datetime <- as.POSIXct("2025-10-18 02:50:00", tz = "America/New_York")
    
    # Call the ppk function to get PPK values
    ppk_vals <- ppk()
    
    # Debugging output
    print("PPK values from ppk function:")
    print(ppk_vals)
    
    return(ppk_vals)
  })
  
  # Render PPK value box
  output$ppk_box <- renderValueBox({
    ppk_vals <- ppk_set()
    value <- if (is.na(ppk_vals["ppk"])) "N/A" else round(ppk_vals["ppk"], 3)
    valueBox(
      value = value,
      subtitle = "Current PPK",
      icon = icon("chart-line"),
      color = "blue"
    )
  })
  
  # Render Predicted PPK value box
  output$predicted_ppk_box <- renderValueBox({
    ppk_vals <- ppk_set()
    value <- if (is.na(ppk_vals["predicted_ppk"])) "N/A" else round(ppk_vals["predicted_ppk"], 3)
    valueBox(
      value = value,
      subtitle = "Predicted PPK if High Risk Patients are Checked",
      icon = icon("chart-line"),
      color = "teal"
    )
  })
  
  # Reactive sorting based on input
  sorted_data <- reactive({
    data <- priority()  
    
    if (input$sort_choice == "Priority Score") {
      data <- data %>% arrange(desc(PriorityScore))
    } else if (input$sort_choice == "Hours Since Last Checked") {
      data <- data %>% arrange(desc(HoursSinceChecked))
    } else if (input$sort_choice == "Injury Severity Score") {
      data <- data %>% arrange(desc(InjurySeverityScore))
    }
    
    data
  })
  
  output$patient_table <- renderDT({
    datatable(
      sorted_data(),
      colnames = c("Patient Name", "Hours Since Last Checked", "Injury Severity Score", "Priority Score"),
      options = list(
        pageLength = 10,
        autoWidth = TRUE,
        columnDefs = list(list(className = 'dt-center', targets = "_all")),
        dom = 'Bfrtip',
        buttons = c('excel', 'pdf')
      ),
      rownames = FALSE,
      extensions = 'Buttons',
      class = 'cell-border stripe hover compact'
    ) %>%
      formatStyle(
        'PriorityScore',
        backgroundColor = styleInterval(
          c(0.4, 0.675),
          c('lightgreen', 'khaki', 'lightcoral') 
        )
      )
  })
  
  # Display the High-Risk Patient Count in red using a valueBox
  output$high_risk_count_box <- renderValueBox({
    data <- priority()
    # Define a threshold for "High Risk" (e.g., Priority Score > 80)
    high_risk_threshold <- 0.675
    high_risk_count <- sum(data$PriorityScore > high_risk_threshold)  # Count patients with high priority
    
    valueBox(
      value = high_risk_count,  # Display the count of high-risk patients
      subtitle = "High-Risk Patients",
      icon = icon("exclamation-triangle"),
      color = "red"  # Red color for the box
    )
  })
  
  # Render the legend in text format (using R textOutput)
  output$color_legend <- renderUI({
    tagList(
      # Create colored boxes for the legend
      div(style = "display: inline-block; width: 30px; height: 30px; background-color: lightgreen; margin-right: 10px;"),
      "Low Risk", 
      br(),
      div(style = "display: inline-block; width: 30px; height: 30px; background-color: khaki; margin-right: 10px;"),
      "Medium Risk",
      br(),
      div(style = "display: inline-block; width: 30px; height: 30px; background-color: lightcoral; margin-right: 10px;"),
      "High Risk"
    )
  })
  
  output$spc_chart <- renderPlot({
    data <- sorted_data()  # your reactive, sorted dataframe
    
    # Use the 'Hours Since Last Checked' column
    wait_times <- data$HoursSinceChecked
    
    # Compute mean and control limits
    mean_time <- mean(wait_times, na.rm = TRUE)
    sd_time <- sd(wait_times, na.rm = TRUE)
    UCL <- mean_time + 3 * sd_time
    LCL <- 0
    
    # Define priority levels for coloring
    priority_mean <- mean(data$PriorityScore, na.rm = TRUE)
    priority_sd <- sd(data$PriorityScore, na.rm = TRUE)
    data$PriorityLevel <- cut(
      data$PriorityScore,
      breaks = c(-Inf, 0.4, 0.675, Inf),
      labels = c("Low", "Medium", "High")
    )
    
    # Plot the SPC chart
    ggplot(data, aes(x = seq_len(nrow(data)), y = wait_times, color = PriorityLevel)) +
      geom_point(size = 3) +
      geom_line(aes(group = 1), color = "gray70") +
      geom_hline(yintercept = mean_time, color = "green", linetype = "dashed", linewidth = 1) +
      geom_hline(yintercept = UCL, color = "red", linetype = "dashed", linewidth = 1) +
      geom_hline(yintercept = LCL, color = "red", linetype = "dashed", linewidth = 1) +
      scale_color_manual(values = c("Low" = "green", "Medium" = "yellow", "High" = "red", "High" = "red")) +
      labs(
        title = "SPC Chart for Patient Wait Times",
        x = "Patient Index",
        y = "Hours Since Last Checked", 
        color = "Priority Level"
      ) +
      theme_minimal()
  })
  
  
  
}

# Run the Shiny app
shinyApp(ui, server)
