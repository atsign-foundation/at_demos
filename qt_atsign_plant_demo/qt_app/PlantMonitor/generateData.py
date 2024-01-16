import random

data = {
    'Soil Moisture': [[1, 34.53], [2, 40.26]],
    'Temperature': [[1, 21.32], [2, 22.15]],
    'Humidity': [[1, 67.48], [2, 71.42]],
    'Water Level': [[1, 90.42], [2, 88.26]]
}

# Define the rules
soil_moisture_rule = [20, 60]
temperature_rule = [21, 24]
humidity_rule = [60, 80]
water_level_rule = [30, 90]

# Generate data for the remaining days (3 to 29)
for day in range(3, 30):
    # Generate random values within the specified rules
    soil_moisture = round(random.uniform(soil_moisture_rule[0], soil_moisture_rule[1]), 2)
    temperature = round(random.uniform(temperature_rule[0], temperature_rule[1]), 2)
    humidity = round(random.uniform(humidity_rule[0], humidity_rule[1]), 2)

    # Water level jumps straight back to 90 once it reaches 30
    if day == 16:
        water_level = 90.0
    else:
        # Continue gradual decline pattern
        if day < 16:
            water_level = round(90 - (day - 3) * (60 / 13), 2)
        else:
            water_level = round(90 - (day - 16) * (60 / 13), 2)

    # Append the generated data to the respective lists
    data['Soil Moisture'].append([day, soil_moisture])
    data['Temperature'].append([day, temperature])
    data['Humidity'].append([day, humidity])
    data['Water Level'].append([day, water_level])

# Print the expanded data
print(data)
