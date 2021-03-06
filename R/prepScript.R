# Prep Script

install.packages("plotly")
library(plotly)

library(readr)
water_consumed <- read_csv("waterConsumption.csv")
View(water_consumed)
GallonsOz <- (water_consumed$LitersKg / 35.2739619) / 3.7854118
GallonsOz <- round(GallonsOz)
water_consumed <- cbind(water_consumed, GallonsOz)

library(plyr)
water_consumed <- rename(water_consumed, c("Ingredient"="Food"))

resources_consumed <- read_csv("resourcesConsumed.csv")
View(resources_consumed)
resources_consumed$EcoScore <- (resources_consumed$Water + resources_consumed$Grain + resources_consumed$Land + resources_consumed$CO2)

# Round decimal values to 3 decimal points
# CO2
is.num <- sapply(resources_consumed$CO2, is.numeric)
resources_consumed$CO2[is.num] <- lapply(resources_consumed$CO2[is.num], round, 3)
# Grain
is.num <- sapply(resources_consumed$Grain, is.numeric)
resources_consumed$Grain[is.num] <- lapply(resources_consumed$Grain[is.num], round, 3)
# Land
is.num <- sapply(resources_consumed$Land, is.numeric)
resources_consumed$Land[is.num] <- lapply(resources_consumed$Land[is.num], round, 4)

class(resources_consumed)

chicken_dishes <- read_csv("chicken_dishes.csv")
View(chicken_dishes)
chicken_dishes$Water <- chicken_dishes$`Amount (oz)` * 32
chicken_dishes$CO2 <- chicken_dishes$`Amount (oz)` * 0.211
chicken_dishes$Land <- chicken_dishes$`Amount (oz)` * 3.125
chicken_dishes$Grain <- chicken_dishes$`Amount (oz)` * 0.262

beef_dishes <- read_csv("beef_dishes.csv")
View(beef_dishes)
beef_dishes$Water <- beef_dishes$`Amount (oz)` * 115
beef_dishes$CO2 <- beef_dishes$`Amount (oz)` * 0.938
beef_dishes$Land <- beef_dishes$`Amount (oz)` * 15.625
beef_dishes$Grain <- beef_dishes$`Amount (oz)` * 0.412

pork_dishes <- read_csv("pork_dishes.csv")
View(pork_dishes)
pork_dishes$Water <- pork_dishes$`Amount (oz)` * 45
pork_dishes$CO2 <- pork_dishes$`Amount (oz)` * 0.422
pork_dishes$Land <- pork_dishes$`Amount (oz)` * 4.375
pork_dishes$Grain <- pork_dishes$`Amount (oz)` * 0.262

turkey_dishes <- read_csv("turkey_dishes.csv")
View(turkey_dishes)
turkey_dishes$Water <- turkey_dishes$`Amount (oz)` * 30
turkey_dishes$CO2 <- turkey_dishes$`Amount (oz)` * 0.199
turkey_dishes$Land <- turkey_dishes$`Amount (oz)` * 3.125
turkey_dishes$Grain <- turkey_dishes$`Amount (oz)` * 0.15

lamb_dishes <- read_csv("lamb_dishes.csv")
View(lamb_dishes)
lamb_dishes$Water <- lamb_dishes$`Amount (oz)` * 78
lamb_dishes$CO2 <- lamb_dishes$`Amount (oz)` * 1
lamb_dishes$Land <- lamb_dishes$`Amount (oz)` * 14
lamb_dishes$Grain <- lamb_dishes$`Amount (oz)` * 0.194

meat_dishes <- rbind(chicken_dishes, beef_dishes, pork_dishes, turkey_dishes, lamb_dishes)
View(meat_dishes)
meat_dishes$EcoScore <- (meat_dishes$Water + meat_dishes$CO2 + meat_dishes$Land + meat_dishes$Grain) / 11
meat_dishes$EcoScore <- round(meat_dishes$EcoScore)
write.csv(meat_dishes, file = "meat_dishes.csv")

library(plotly)
set.seed(5)
plot_ly(resources_consumed, x = resources_consumed$`Meat Type`, y = resources_consumed$EcoScore, text = paste("CO2: ", resources_consumed$CO2),
        mode = "markers", color = meat_dishes$`Meat Type`, size = resources_consumed$EcoScore)

library(plotly)
set.seed(10)
plot_ly(meat_dishes, x = `Amount (oz)`, y = EcoScore, text = paste("Dish: ", meat_dishes$`Food Item`),
        mode = "markers", color = meat_dishes$`Meat Type`, size = meat_dishes$CO2)

library(plotly)
set.seed(10)
plot_ly(meat_dishes, x = `Meat Type`, y = EcoScore, text = paste("EcoScore: ", meat_dishes$EcoScore),
        mode = "markers", color = meat_dishes$`Meat Type`, size = meat_dishes$Water)

base_plot <- plot_ly(
  type = "pie",
  values = c(40, 10, 10, 10, 10, 10, 10),
  labels = c("-", "0", "20", "40", "60", "80", "100"),
  rotation = 108,
  direction = "clockwise",
  hole = 0.4,
  textinfo = "label",
  textposition = "outside",
  hoverinfo = "none",
  domain = list(x = c(0, 0.48), y = c(0, 1)),
  marker = list(colors = c('rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)', 'rgb(255, 255, 255)')),
  showlegend = FALSE
)

base_plot <- add_trace(
  base_plot,
  type = "pie",
  values = c(50, 10, 10, 10, 10, 10),
  labels = c("Minimal Impact", "Mild Impact", "Medium Impact", "Eco-Unfriendly", "High Impact", ":("),
  rotation = 90,
  direction = "clockwise",
  hole = 0.3,
  textinfo = "label",
  textposition = "inside",
  hoverinfo = "none",
  domain = list(x = c(0, 0.48), y = c(0, 1)),
  marker = list(colors = c('rgb(255, 255, 255)', 'rgb(232,226,202)', 'rgb(226,210,172)', 'rgb(223,189,139)', 'rgb(223,162,103)', 'rgb(226,126,64)')),
  showlegend= FALSE
)

base_plot <- layout(
  base_plot,
  shapes = list(
    list(
      type = 'path',
      path = 'M 0.235 0.5 L 0.24 0.62 L 0.245 0.5 Z',
      xref = 'paper',
      yref = 'paper',
      fillcolor = 'rgba(44, 160, 101, 0.5)'
    )
  ),
  annotations = list(
    list(
      xref = 'paper',
      yref = 'paper',
      x = 0.23,
      y = 0.45,
      showarrow = FALSE,
      text = '50'
    )
  )
)

base_plot
