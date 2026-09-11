library(shiny)
library(shinydashboard)
library(ggplot2)
ui <- dashboardPage(
        dashboardHeader(
                title = "Resolution in Fluorescence Microscopy",
                titleWidth = 300
        ),
            dashboardSidebar(
                width = 300,
                sliderInput(
                    inputId = "lambda",
                    label = "Wavelength:",
                    min = 380,
                    max = 780,
                    step = 5,
                    value = 525),
                sliderInput(
                    inputId = "numericalAperture",
                    label = "Numerical Aperture:",
                    min = 0.25,
                    max = 1.45,
                    step = 0.05,
                    value = 1.30),
                numericInput(
                        inputId= "exposure",
                        label = "exposure time (ms)",
                        min = 0.25,
                        max = 500,
                        step = 0.01,
                        value = 10),
                numericInput(
                  inputId = "pixelSize",
                  label = "Sampling frequency (pixel size) in nm:",
                  value = 25,
                  min = 1,
                  step = 1
                ),
                numericInput(
                  inputId = "separation",
                  label = "Distance between beads (nm or Airy Units, depending on your choice in the 'config' tab):",
                  value = 246,
                  min = 0,
                  step = 1
                ),
                # actionButton(
                #     inputId = "update",
                #     label = "Update PSF!",
                #     icon = icon("play"),
                #     style = "color: #fff; background-color: #337ab7; border-color: #2e6da4"),
                sidebarMenu(
                    menuItem("PSF", tabName = "psf", icon = icon("image")),
                    menuItem("Configuration", tabName = "configuration", icon = icon("cogs")),
                    menuItem("Information", tabName = "information", icon = icon("info"))
                )#sidebarMenu
            ),#dashboardSidebar
            dashboardBody(
                tabItems(
                    tabItem(
                        tabName = "psf",
                        fluidRow(
                            box(
                            title = "PSF",
                            status = "primary",
                            solidHeader = TRUE,
                            imageOutput(outputId = "PSFImage", width = 512, height = 512)
                            ),

                            box(
                            title = "Lineplot",
                            status = "primary",
                            solidHeader = TRUE,
                            plotOutput(outputId = "PSFlineplot", width = 512, height = 512)
                            ) # box
                        ), # fluidRow
                        fluidRow(
                            infoBoxOutput("OpticalResolution", width = 3),
                            infoBoxOutput("NyquistSampling", width = 3),
                            infoBoxOutput("numericalaperture", width = 2),
                            infoBoxOutput("wavelength", width = 2),
                            infoBoxOutput("contrast", width = 2)
                        ),

                        fluidRow(

                        ), # fluidRow
                        fluidRow(
                          box(
                            title = "Resolution:",
                            status = "primary",
                            solidHeader = TRUE,
                            width = 12,
                            p("The line profile provides a one-dimensional view of the image intensity through the centre of the two fluorescent beads.
                              The dashed curves show the contribution from each bead individually, while the red curve shows the sum of both signals.
                              Resolution can be assessed by examining whether two distinct peaks are visible and by measuring the contrast between the
                              central minimum and the peak intensities. According to the Rayleigh criterion, two equally bright point sources are considered
                              resolved when the central dip reaches approximately 73% of the peak intensity, corresponding to a contrast of about 26.5%. At the Abbe limit,
                              the expected contrast is approximately 11%, while at the Sparrow limit the central dip disappears entirely and the contrast falls to 0%,
                              providing no visible evidence of two separate objects. As wavelength, numerical aperture, sampling and noise are varied,
                              the shape of the line profile changes, illustrating how these factors influence the ability to distinguish closely spaced objects.")
                          ) # box
                        ),# fluidRow
                        fluidRow(
                            box(
                            title = "GETTING STARTED:",
                            status = "primary",
                            solidHeader = TRUE,
                            width = 12,
                           p("The most important parameters for this simulation are the
                           wavelength used, the lens numerical aperture, the pixel size,
                           the image size and the separation distance between the fluorescent
                           point sources. Initially these are set to 525nm, 1.3, 25nm,
                           and 32 X 32 and 246 nm (= 0.61 * 525)/1.3. An image is presented as
                           if two fluorescent beads are emitting a wavelength of 525nm, and a lens of 1.3NA
                           is used to collect the light and project it onto an imaging device that
                           records 25nm pixels in a 32X32 array. All of these values are user changeable
                           either in the left sidebar, or in the configuration tab."),
                           p("The display shows the simulated image of two beads in the upper left box, a line
                           plot drawn through the horizontal center of the image, plotting the intensity of each
                           bead separately (dashsed lines), the sum of the intensities (solid red line) and the actual
                           intensities across the image (solid black line). Note that unelss you choose to add noise
                           to your simulation, the solid red and black lines will be on top of each other."),
                           p("In addition to the inputs in the left sidebar, there are three tabs. the 'output' tab,
                           showing the image, graph and information boxes, the 'configuration' tab, containing user
                           selectable options, and the 'information' tab, explaining the simulation in more detail.")
                            ) # box
                        ) # fluidRow
                    ), # tabItem
                    tabItem(
                        tabName = "configuration",
                        fluidRow(
                            box(
                                title = "Image Size",
                                status = "primary",
                                solidHeader = TRUE,
                                selectInput(
                                    inputId = "imageSize",
                                    label = "Image Size: (e.g. '32' means 32 pixels by 32 pixels)",
                                    choices = c(8,16,32,64,128,256,512,1024),
                                    selected = 32)
                            ),
                            box(
                                title = "Model",
                                status = "primary",
                                solidHeader = TRUE,
                                radioButtons(
                                    inputId = "model",
                                    label = "Choose which type of function will be used to model the PSF:",
                                    choices = c("Gaussian","Bessel"),
                                    selected = "Bessel",
                                    inline = TRUE)
                            ) #box
                        ), #fluidRow
                        fluidRow(
                            box(
                                title = "Colourscheme",
                                status = "primary",
                                solidHeader = TRUE,
                                radioButtons(
                                    inputId = "colourscheme",
                                    label = "Choose whether you want the image to be displayed in grayscale or colour:",
                                    choices = c("grayscale","colour"),
                                    selected = "colour",
                                    inline = TRUE)
                            ),
                            box(
                                    title = "Noise",
                                    status = "primary",
                                    solidHeader = TRUE,
                                    checkboxInput(
                                            inputId = "noise",
                                            label = "Add noise to your image?",
                                            value = FALSE)
                            )
                        ), #fluidRow
                        fluidRow(
                            box(
                                title = "Enhance",
                                status = "primary",
                                solidHeader = TRUE,
                                checkboxInput(
                                    inputId = "enhance",
                                    label = "Enhance the image to see the diffraction rings? (only useful if 'Bessel' us used as the function for calculating the PSF)",
                                    value = FALSE)
                            ),
                            box(
                                title = "Separation",
                                status = "primary",
                                solidHeader = TRUE,
                                radioButtons(
                                    inputId = "distance_units",
                                    label = "Do you want to plot the PSF separation using nm or Airy Units?",
                                    choices = c("nm", "Airy"),
                                    selected = "nm",
                                    inline = TRUE)
                            ),#box
                            box(
                              title = "Configuration Options",
                              width = 12,
                              status = "primary",
                              solidHeader = TRUE,
                              p("The simulation can be customised to explore how different factors influence the appearance and
                                resolution of fluorescent point sources. The Image Size setting controls the number of pixels in the simulated image.
                                Larger images provide a wider field of view and more detailed visualisation of the point spread functions,
                                but may take longer to calculate.  Two different models can be used to generate the point spread function (PSF).
                                The Gaussian model is a simple approximation that captures the overall shape of a diffraction-limited spot,
                                while the Bessel model produces an Airy pattern that more accurately represents diffraction through a circular microscope
                                objective and includes diffraction rings.
                                The Colour Scheme option allows the image to be displayed either in grayscale or using a colour corresponding to the
                                selected wavelength. The Enhance option applies a non-linear intensity scaling to make the diffraction rings of the Airy
                                pattern easier to see. This is primarily useful when the Bessel model is selected.
                                Enabling Noise adds simulated photon shot noise and detector read noise to the image,
                                illustrating how experimental noise can affect the ability to distinguish closely spaced objects.
                                Finally, the Separation Units option allows the spacing between the two point sources to be specified either in nanometres
                                or in Airy units, making it easier to compare the simulated separation with classical resolution criteria such as the Abbe,
                                Rayleigh and Sparrow limits.")
                            )#box
                        )#fluidRow
                    ),#tabItem
                    tabItem(
                        tabName = "information",
                        fluidRow(
                            box(
                                title = "Information and Instructions",
                                width = 12,
                                status = "primary",
                                solidHeader = TRUE,
                                p("This app is designed to explore the relationship between
                                  resolution, Numerical Aperture and the wavelength in fluorescence
                                  microscopy. A commonly accepted limit of resolution is the 'Rayleigh limit'
                                  depeding only on NA and wavelength. This limit applies to noise-free sub-resolution
                                  fluorescent sources that are equally bright. But other factors also have an influence on
                                  the ability to resolve point sources, e.g. the ability to distinguish the signal from the
                                  noise and the pixel size of the detector. In this application, the point spread function (psf)
                                  of two point sources is calculated and a simulated image is shown to the user as well as an intensity
                                  lineplot through the center of the two point sources. The psf is calculated either by using a 2D
                                  Gaussian function that has equal standard deviations in x and y, or a first order Bessel function
                                  of the first kind using the following equations: "),
                                br(),
                                p("Bessel:"), img(src = "Bessel.svg"),
                                br(),
                                br(),
                                br(),
                                p("2-D Gaussian:"), img(src = "2DGaussian.svg"),
                                p("For an in-dpeth discussion see et al for details")

                                ),#box

                        )#fluidRow
                    )#tabItem
            )#tabItems
        )#dashboardBody
)#dashboardPage

server <- function(input, output){

#--------------------------------------------------------------------------------
#
#                       This function will convert user input wavelength in nm to
#                       a colour with RGB values, and return these values as a
#                       vector of length 3.
#                       Modified from FORTRAN code found here:
#                       http://www.physics.sfasu.edu/astro/color/spectra.html
#                       by Dan Bruton
#--------------------------------------------------------------------------------

    wavelengthToRGB<- function(wave) {
        g<- 0.8 # gamma. RGB values assumed to vary linearly with wavelength if g = 1.
                # All examples have the gamma set to 0.8. Not sure why?, perhaps to
                #compensate for viewing on a computer monitor, a graphics device with
                #a non-linear response?

        intensitymax<- 255  # 8-bit values
        f <- 0.0
        Red <- 0.0
        Green <- 0.0
        Blue <- 0.0
        RGB <- c(0.0,0.0,0.0)

          if ((wave >= 380) & (wave < 440)) {
               Red <- -(wave - 440) / (440 - 380)
               Green<- 0.0
               Blue<- 1
          } else if ((wave >=440) & (wave < 490)) {
               Red<- 0.0
               Green<- (wave - 440) / (490 - 440)
               Blue<- 1
          } else if ((wave >= 490) & (wave < 510)) {
               Red <- 0.0
               Green <- 1
               Blue <- -(wave - 510) / (510 - 490)
          } else if ((wave >=510) & (wave < 580)) {
               Red <- (wave - 510) / (580 - 510)
               Green <- 1
               Blue <- 0.0
          } else if ((wave >= 580) & (wave < 645)) {
               Red <- 1
               Green <- -(wave - 645) / (645 - 580)
               Blue <- 0.0
          } else if ((wave >= 645) & (wave < 781)){
               Red <- 1
               Green <- 0.0
               Blue <- 0.0
          } else {
               Red <- 0.0
               Green <- 0.0
               Blue <- 0.0
          }
          # Use a factor variable "f" to let the intensity fall at both ends of the spectrum
          #         if ((wave >=380) & (wave < 420)){
          #               f <-  0.3 + 0.7*(wave - 380) / (420 - 380)
          #         } else if ((wave >=420) & (wave < 701)) {
          #             f <- 1.0
          #       } else if ((wave >=701) & (wave < 781)) {
          #           f <- 0.3 + 0.7*(780 - wave) / (780 - 700)
          #    }  else {
          #        f <- 0.0
          #  }
          # For this purpose, I don't need to have the intensity fall off at the ends of the spectrum.
          # So let f always be 1.0.
          f<-1.0
          if (Red == 0.0) {
               RGB[1] <- 0
          } else {
               RGB[1] <- round(intensitymax*(Red*f)^g)
          }
          if (Green == 0.0) {
               RGB[2] <- 0
          } else {
               RGB[2] <- round(intensitymax*(Green*f)^g)
          }
          if (Blue == 0.0) {
               RGB[3] <- 0
          } else {
               RGB[3] <- round(intensitymax*(Blue*f)^g)
          }

          return(RGB)
     } # Function wavelengthToRGB()

#--------------------------------------------------------------------------------
#
#                       This is the function that calculate the values of the
#                       image matrix. It uses either R's besselJ function or a
#                       2 dimensional Gaussian to model a point source viewed
#                       through a microscope given an xy coordinate system, wavelength
#                       lens NA, assuming we're using this to calculate the psf
#                       not at the center but at some x offset (separation distance),
#                       whether this offset should be in Airy units or nm, which model
#                       (Bessel Vs Gaussian) and the pixel size of the resulting matrix.
#                       The image always has an y offset of 0. The function returns
#                       a matrix z of values that can be plotted versus their
#                       xy coordinates to simulate a psf for a point source. No noise
#                       is considered.
#
#--------------------------------------------------------------------------------
    immatrix <- function(x, y, wave, NumAper,
                         sep, units, mod, pix.size) {

      x.center <- 0

      if (units == "nm") {
        x.center <- -sep/2
      } else {
        x.center <- -((sep*1.22*wave)/NumAper)/2
      }

      X <- outer(x, rep(1, length(y)))
      Y <- outer(rep(1, length(x)), y)

      if (mod == "Bessel") {

        rprime <- sqrt((X - x.center)^2 + Y^2) *
          (2*pi*NumAper/wave)

        z <- (2*besselJ(rprime, 1)/rprime)^2

        z[rprime == 0] <- 1

      } else {

        sigma <- 0.21*wave/NumAper

        z <- exp(
          -((X - x.center)^2 + Y^2) /
            (2*sigma^2)
        )
      }

      z
    }
#Now I have a matrix that has values between 0 and 1
 # Function immatrix() ------------------------------------------------

    combine_matrices <- function(matrix1,matrix2,exposure_time, noise){

             counts <- exposure_time*27.788+67.08
             sd <- exposure_time*0.0097+6.605
             z <- round(matrix1*counts+matrix2*counts,0)
             if (noise == TRUE){
               # shot_noise <- matrix(0,nrow=dim(matrix1)[1],dim(matrix1)[2])
               # read_noise <- matrix(0,nrow=dim(matrix1)[1],dim(matrix1)[2])
               shot_noise <- matrix(
                 rpois(length(z), lambda = c(z)) - c(z),
                 nrow = nrow(z)
               )

               read_noise <- matrix(
                 rnorm(length(z), mean = 0, sd = sd),
                 nrow = nrow(z)
               )
                z <- z + shot_noise + read_noise
                z[z < 0] <- 0
             }
             z<- z/max(z) # normalize to values between 0 and 1
             return(z)

    }

#--------------------------------------------------------------------------------
#
#                       Calculate reactive quantities to use later
#
#--------------------------------------------------------------------------------
    d <- reactive({
      0.61 * input$lambda / input$numericalAperture
    })

    numAp <- reactive({
      input$numericalAperture
    })

    wave <- reactive({
      input$lambda
    })

    points <- reactive({
      imageSize <- as.numeric(input$imageSize)

      seq(
        -imageSize/2 * input$pixelSize,
        imageSize/2 * input$pixelSize,
        length.out = imageSize + 1
      )
    })

    z1 <- reactive({
      immatrix(
        points(),
        points(),
        input$lambda,
        input$numericalAperture,
        input$separation,
        input$distance_units,
        input$model,
        input$pixelSize
      )
    })

    z2 <- reactive({
      immatrix(
        points(),
        points(),
        input$lambda,
        input$numericalAperture,
        -input$separation,
        input$distance_units,
        input$model,
        input$pixelSize
      )
    })


    sum_i <- reactive({
      combine_matrices(
        z1(),
        z2(),
        input$exposure,
        input$noise
      )
    })

#--------------------------------------------------------------------------------
#
#                       Calculate the contrast between the min and max
#                       of the peaks
#--------------------------------------------------------------------------------
     peak.contrast <- function (matrix1, sep, pixelSize) {
        x.middle <-(((ncol(matrix1))-1)/2) + 1
        y.middle <- x.middle
        min <- matrix1[x.middle,y.middle]
        peak <- round((sep/2)/pixelSize)
        max1<- matrix1[(x.middle+peak),y.middle]
        max2<- matrix1[(x.middle-peak),y.middle]
        max <- mean(c(max1,max2))
        #min <- pix_data[y.middle]
        c <- (max-min)/(max+min)
        if (c < 0) {
                c <- 0
        }
        return(c)
     }#peak.contrast

    contrast <- reactive({
      peak.contrast(
        sum_i(),
        input$separation,
        input$pixelSize
      )
    })


#--------------------------------------------------------------------------------
#
#                       OUTPUTS
#
#--------------------------------------------------------------------------------


#--------------------------------------------------------------------------------
#
#                       PNG Image Output
#
#--------------------------------------------------------------------------------
     output$PSFImage <- renderImage({
         x <- points()
         y <- points()
                if (input$enhance == TRUE) {
                        z <- sum_i()^(1/3)
                } else {
                        z <- sum_i()
                }

         rgbplotcolour <-wavelengthToRGB(wave())
         if (input$colourscheme == "grayscale") {
            plotcolour <- "white"
         } else {
            plotcolour <- rgb(rgbplotcolour[1],rgbplotcolour[2],rgbplotcolour[3],maxColorValue = 255)
         }
         colfunc<-colorRampPalette(c("black",plotcolour))
         outfile <- tempfile(fileext = ".png")
         png(outfile, width = 512, height = 512)
         image(x,y,z,
               col = colfunc(256),
               bty = "n", las = 1,
               mar = c(0,0,0,0),
               cex.lab = 1, cex.axis = 1,
               xlab = "Distance (nm)", ylab = "Distance (nm)"
               )
         dev.off()
         list(src = outfile)

         }, deleteFile = TRUE
     )#renderImage

#--------------------------------------------------------------------------------
#
#                       Generate the plot output
#
#--------------------------------------------------------------------------------
    linePlot <- reactive({
      imageSize <- as.numeric(input$imageSize)
      x <- points()

      if (input$noise) {
        z <- sum_i()
        both <- z[, imageSize/2 + 1]
      } else {
        z <- z1() + z2()
        both <- z[, imageSize/2 + 1]
      }

      sumz <- z1() + z2()

      sum <- sumz[, imageSize/2 + 1]
      first <- z1()[, imageSize/2 + 1]
      second <- z2()[, imageSize/2 + 1]

      df <- data.frame(x, both, first, second, sum)

      ggplot(data = df) +
        geom_line(aes(x = x, y = both)) +
        geom_line(aes(x = x, y = first), linetype = 2) +
        geom_line(aes(x = x, y = second), linetype = 2) +
        geom_line(aes(x = x, y = sum),
                  colour = "red") +
        labs(
          x = "distance (nm)",
          y = "Fluorescence Intensity (arbitrary units)"
        ) +
        theme_classic()
    })

#--------------------------------------------------------------------------------
#
#                       Render the plot output
#
#--------------------------------------------------------------------------------

    output$PSFlineplot <- renderPlot({
        linePlot()},
        width = 512,
        height = 512
    ) #renderPlot

#--------------------------------------------------------------------------------
#
#                       Render the infobox output
#
#--------------------------------------------------------------------------------

     output$OpticalResolution <- renderInfoBox ({
         infoBox(
             title = "Rayleigh resolution:",
             value = paste(round(d()), " nm"),
             #subtitle = "(0.61*lambda/NA) = 0.5 Airy Units",
             icon = icon("calculator"),
             fill= TRUE,
             color = "aqua"
         ) #infoBox
     }) #renderInfoBox

     output$NyquistSampling <- renderInfoBox ({
         if (input$pixelSize < 1.05*(d()/2.3)) {
             infoBox(
                 title = "Sampling is good",
                 value = paste(input$pixelSize, " nm pixel"),
                 subtitle = paste("Optimal pixel size = ", round(d()/2.3), " nm"),
                 icon = icon("face-smile"),
                 fill = TRUE,
                 color = "green"
             ) #infoBox
         } else if  ((input$pixelSize >= 1.05*(d()/2.3)) && (input$pixelSize < 1.15*(d()/2.3))) {
             infoBox(
                 title = "Sampling is ok",
                 value = paste(input$pixelSize, " nm pixel"),
                 subtitle = paste("Optimal pixel size = ", round(d()/2.3), " nm"),
                 icon = icon("face-meh"),
                 fill = TRUE,
                 color = "yellow"
             ) #infoBox
         } else {
             infoBox(
                 title = "Sampling is not met",
                 value = paste(input$pixelSize, " nm pixel"),
                 subtitle = paste("Optimal pixel size = ", round(d()/2.3), " nm"),
                 icon = icon("face-frown"),
                 fill = TRUE,
                 color = "red"
             ) #infoBox
         } # else
     }) #renderInfoBox

     output$numericalaperture  <- renderInfoBox({ infoBox("N.A.:", numAp()) })
     output$wavelength         <- renderInfoBox({ infoBox(tags$span(style = "text-transform:lowercase",HTML("&#x03BB")), paste(wave(), " nm")) })
     output$contrast           <- renderInfoBox({ infoBox("Contrast:", paste(round(100*contrast(),digits = 1), " %"))  })
        # subtitle = "(MAX-MIN/MAX+MIN)")

} #server
shinyApp(ui=ui, server=server)
