# Uber Trip Data Analysis - R Shiny Dashboard

An interactive R Shiny dashboard for analyzing Uber trip data in New York City from April to September 2014. This app visualizes ride patterns by hour, day, base, and geography using plots, heatmaps, and maps.

---

##  Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Data Sources](#data-sources)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Technologies Used](#technologies-used)
- [Contributing](#contributing)
- [License](#license)

---

##  Features

- 📊 **Dynamic Visualizations** of Uber trip patterns by:
  - Hour
  - Day
  - Base
  - Week
  - Month
- 🗺️ **Interactive Map**: Leaflet map with trip markers and date filtering
- 🔥 **Heatmaps**: Patterns by hour/day, day/month, base/day of week, etc.
- 🔮 **Prediction Overview**: Visual insights into trip patterns useful for modeling

---

## 📷 Screenshots

| Trip Counts by Hour and Month | Leaflet Trip Map |
|------------------------------|------------------|
| ![Plot Example](images/plot-hour-month.png) | ![Map Example](images/map-leaflet.png) |

*(Add actual screenshots to the `images/` folder and update paths)*

---

## 📁 Data Sources

- `uber-raw-data-apr14.csv`
- `uber-raw-data-may14.csv`
- `uber-raw-data-jun14.csv`
- `uber-raw-data-jul14.csv`
- `uber-raw-data-aug14.csv`
- `uber-raw-data-sep14.csv`

Each dataset contains:
- `Date.Time`: Pickup datetime
- `Lat`, `Lon`: Pickup latitude and longitude
- `Base`: Base number affiliated with trip

---

## 🛠️ Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/uber-trip-analysis.git
cd uber-trip-analysis
```
