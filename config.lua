Config = {}

-- Health threshold below which thirst and hunger effects are applied
Config.LowHealthThreshold = 150

-- How fast health changes when hungry or thirsty
-- They are both called independently so if thirsty and hungry, the values will add up
Config.ThirstRateOfChange = 0.2
Config.HungerRateOfChange = 0.2

-- How fast Thirst and Hunger effect health below 150 health
Config.LowHealthMultiplier = 1