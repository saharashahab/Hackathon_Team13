library(shiny)
library(shinydashboard)
library(DT)
library(dplyr)
library(ggplot2)
source("PriorityTable.R")
source("ppk.R")

# UI
ui <- dashboardPage(
  dashboardHeader(title = "Hospital Wait Time Quality Control", titleWidth = 400),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    h2("", style = "color: #007BFF; text-align: center;"),
    fluidRow(
      column(12,
             box(
               title = "Dashboard Overview",
               width = NULL,
               status = "info",
               solidHeader = TRUE,
               collapsible = TRUE,
               collapsed = FALSE,
               p("Welcome to the Hospital Wait Time Quality Control Dashboard! This tool is designed to help doctors prioritize patients based on their injury severity, wait times, and check-in frequency."),
               p("Use the Sort By feature to sort the patient priority table by Injury Severity Score (ISS), Hours Since Last Checked, or the calculated Priority Score. The table highlights high-priority patients with colors."),
               p("The SPC chart on the right helps monitor overall patient wait times and identify any unusually long waits. The high-risk patient count shows how many patients need urgent attention based on priority score."),
               p("Please upload your CSV dataset using the file input below to update the dashboard with real-time data.")
             )
      )
    ),
    # First row: Two columns
    fluidRow(
      # First column (left): Widgets and Patient Overview Table
      column(8, 
             # First row (inside the first column): Widgets (Dropdown, Legend, High-Risk Count)
             fluidRow(
               column(4,  # Left side: Dropdown menu
                      uiOutput("file_input_ui"),
                      box(
                        title = "Display Options",
                        width = NULL,
                        solidHeader = TRUE,
                        status = "primary",
                        selectInput(
                          inputId = "sort_choice",
                          label = "Sort Patient by Criteria:",
                          choices = c("Injury Severity Score", "Hours Since Last Checked", "Priority Score"),
                          selected = "Priority Score",
                          width = "100%"
                        )
                        # MODIFIED: Replaced fileInput with uiOutput
                        #uiOutput("file_input_ui")
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
               column(12,  # Full-width: SPC chart
                      box(
                        title = "Statistical Process Control (SPC) Chart",
                        width = NULL,
                        solidHeader = TRUE,
                        status = "primary",
                        plotOutput("spc_chart", height = "300px")  # Display SPC chart with appropriate height
                      )
               )
             ),
             fluidRow(
               column(12,
                      box(
                        title = "SPC Interpretation",
                        width = NULL,
                        solidHeader = TRUE,
                        status = "info",
                        uiOutput("spc_interpretation")
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
             ),
             fluidRow(
               column(12,
                      box(
                        title = "PPK Interpretation",
                        width = NULL,
                        solidHeader = TRUE,
                        status = "info",
                        uiOutput("ppk_interpretation")
                      )
               )
             )
      )
    ),
    fluidRow(
      column(12,
             div(
               style = "text-align: center; font-size: 12px; color: #555; margin-top: 20px;",
               "Developed by: Eileen Ho, Maia Marshall, Harish Kamble, Mark Tarazi, Sahara Shahab"
             )
      )
    )
  )
)

# Server logic
server <- function(input, output, session) {  # MODIFIED: Added session parameter
  # Define current datetime
  current_datetime <- as.POSIXct("2025-10-18 10:18:00", tz = "America/New_York")
  
  # NEW: Reactive value to track if a CSV has been uploaded
  has_uploaded <- reactiveVal(FALSE)
  
  # NEW: Show modal dialog on app start with description if no CSV has been uploaded
  observe({
    if (!has_uploaded()) {
      showModal(modalDialog(
        title = "Welcome to the Hospital Wait Time Quality Control Dashboard",
        tagList(
          p("Welcome to the Hospital Wait Time Quality Control Dashboard! This tool is designed to help doctors prioritize patients based on their injury severity, wait times, and check-in frequency."),
          p("Use the Sort By feature to sort the patient priority table by Injury Severity Score (ISS), Hours Since Last Checked, or the calculated Priority Score. The table highlights high-priority patients with colors."),
          p("The SPC chart on the right helps monitor overall patient wait times and identify any unusually long waits. The high-risk patient count shows how many patients need urgent attention based on priority score."),
          p("Please upload your CSV dataset to update the dashboard with real-time data:"),
          fileInput(
            inputId = "upload",
            label = "Upload CSV File",
            accept = ".csv"
          )
        ),
        footer = NULL,  # No default buttons
        easyClose = FALSE,  # Prevent closing without uploading
        size = "l"  # Larger modal to accommodate description
      ))
    }
  })
  
  # NEW: Render fileInput in the original UI after first upload
  output$file_input_ui <- renderUI({
    if (has_uploaded()) {
      fileInput(
        inputId = "upload",
        label = "Upload CSV File",
        accept = ".csv"
      )
    }
  })
  
  # NEW: Close modal after successful upload
  observeEvent(input$upload, {
    if (!is.null(input$upload)) {
      removeModal()  # Close the modal once a file is uploaded
    }
  })
  
  # MODIFIED: Reactive for data
  data_reactive <- reactive({
    if (is.null(input$upload)) {
      read.csv("Hackathon_Data1.csv", stringsAsFactors = FALSE)
    } else {
      # NEW: Set has_uploaded to TRUE once a file is uploaded
      has_uploaded(TRUE)
      read.csv(input$upload$datapath, stringsAsFactors = FALSE)
    }
  })
  
  # Compute PPK values by calling the ppk function
  ppk_set <- reactive({
    # Call the ppk function to get PPK values
    ppk_vals <- ppk(data_reactive(), current_datetime)
    
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
    data <- priority(data_reactive(), current_datetime)  
    
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
    data <- priority(data_reactive(), current_datetime)
    # Define a threshold for "High Risk" (e.g., Priority Score > 0.675)
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
    # Use data from priority() and sort by PriorityScore for SPC chart
    data <- priority(data_reactive(), current_datetime) %>% arrange(desc(PriorityScore))
    
    # Use the 'HoursSinceChecked' column
    wait_times <- data$HoursSinceChecked
    
    # Compute mean
    mean_time <- mean(wait_times, na.rm = TRUE)
    
    # Compute moving ranges and estimate sd using moving range method
    if (length(wait_times) > 1) {
      moving_ranges <- abs(diff(wait_times))
      avg_mr <- mean(moving_ranges, na.rm = TRUE)
    } else {
      avg_mr <- 0  # If only one data point, no moving range
    }
    
    # Compute control limits (using 2.66 for UCL and LCL as per moving range constant for n=2)
    UCL <- mean_time + 2.66 * avg_mr
    LCL <- max(0, mean_time - 2.66 * avg_mr)
    
    # Define priority levels for coloring
    data$PriorityLevel <- cut(
      data$PriorityScore,
      breaks = c(-Inf, 0.4, 0.675, Inf),
      labels = c("Low", "Medium", "High")
    )
    
    # Plot the SPC chart with annotations for mean and UCL
    ggplot(data, aes(x = seq_len(nrow(data)), y = wait_times, color = PriorityLevel)) +
      geom_point(size = 3) +
      geom_line(aes(group = 1), color = "gray70") +
      geom_hline(yintercept = mean_time, color = "green", linetype = "dashed", linewidth = 1) +
      geom_hline(yintercept = UCL, color = "red", linetype = "dashed", linewidth = 1) +
      geom_hline(yintercept = LCL, color = "red", linetype = "dashed", linewidth = 1) +
      # Add annotations for mean and UCL
      annotate(
        "text",
        x = 1,
        y = mean_time,
        label = paste("Mean:", round(mean_time, 2)),
        vjust = -0.5,
        hjust = 0,
        color = "green",
        size = 4
      ) +
      annotate(
        "text",
        x = 1,
        y = UCL,
        label = paste("UCL:", round(UCL, 2)),
        vjust = -0.5,
        hjust = 0,
        color = "red",
        size = 4
      ) +
      scale_color_manual(values = c("Low" = "green", "Medium" = "yellow", "High" = "red")) +
      labs(
        title = "SPC Chart for Patient Wait Times (Ordered by Priority Score)",
        x = "Patient Index (by Priority Score)",
        y = "Hours Since Last Checked", 
        color = "Priority Level"
      ) +
      theme_minimal() + 
      guides(color = "none")
  })
  
  output$ppk_interpretation <- renderUI({
    req(ppk_set())  # Ensure PPK values are available
    ppk_vals <- ppk_set()
    
    current_ppk <- round(ppk_vals["ppk"], 3)
    predicted_ppk <- round(ppk_vals["predicted_ppk"], 3)
    
    # Determine colors based on thresholds
    current_color <- if(current_ppk < 0.67) "red" else if(current_ppk < 1) "yellow" else "green"
    predicted_color <- if(predicted_ppk < 0.67) "red" else if(predicted_ppk < 1) "yellow" else "green"
    
    HTML(paste0(
      "<p><b>Current PPK:</b> <span style='color:", current_color, "'>", current_ppk, "</span>. ",
      "A PPK above 1 indicates a well-controlled process. Values below 1 suggest the process may need improvement.</p>",
      "<p><b>Predicted PPK:</b> <span style='color:", predicted_color, "'>", predicted_ppk, "</span>. ",
      "If this value increases after high-risk patients are attended to, it shows that the process is improving and patient wait times are being mitigated.</p>"
    ))
  })
  
  output$spc_interpretation <- renderUI({
    data <- priority(data_reactive(), current_datetime) %>% arrange(desc(PriorityScore))
    
    # Extract wait times
    wait_times <- data$HoursSinceChecked
    
    # Validate data
    if (length(wait_times) == 0 || all(is.na(wait_times))) {
      return(div(
        style = "padding: 10px; background-color: orange; color: white; border-radius: 5px;",
        "No valid wait time data available."
      ))
    }
    
    # Compute mean
    mean_time <- mean(wait_times, na.rm = TRUE)
    
    # Compute moving ranges and estimate sd using moving range method
    if (length(wait_times) > 1) {
      moving_ranges <- abs(diff(wait_times))
      avg_mr <- mean(moving_ranges, na.rm = TRUE)
    } else {
      avg_mr <- 0  # If only one data point, no moving range
    }
    
    # Compute control limits (aligned with spc_chart)
    UCL <- mean_time + 2.66 * avg_mr
    LCL <- max(0, mean_time - 2.66 * avg_mr)
    
    # Count points outside control limits
    points_above_UCL <- sum(wait_times > UCL, na.rm = TRUE)
    points_below_LCL <- sum(wait_times < LCL, na.rm = TRUE)
    total_outside <- points_above_UCL + points_below_LCL
    
    # Determine message and color
    if (total_outside == 0) {
      message <- "All patient wait times are within control limits. Please prioritize patients based on priority scores!"
      box_color <- "green"
    } else {
      message <- paste(total_outside, "Paitent wait time(s) is outside control limits. Please immediately check patients with wait times above the UCL.")
      box_color <- "red"
    }
    
    # Display the message with colored background
    div(
      style = paste0("padding: 10px; background-color: ", box_color, "; color: white; border-radius: 5px;"),
      message
    )
  })
}

# Run the Shiny app
shinyApp(ui, server)