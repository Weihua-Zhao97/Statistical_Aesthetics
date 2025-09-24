<div id="user-content-toc" align="center">
  <ul>
  <summary><h1> <p> Statistical Aesthetics </p> </h1></summary>
  <p align='center'>
   <a><img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white" /></a>  
  &nbsp;
   <a><img src="https://img.shields.io/badge/RStudio-75AADB?style=for-the-badge&logo=RStudio&logoColor=white" />
  &nbsp;
   <a><img src="https://img.shields.io/badge/Python-FFD43B?style=for-the-badge&logo=python&logoColor=blue" /></a>
  &nbsp;
   <a><img src="https://img.shields.io/badge/PyCharm-000000.svg?&style=for-the-badge&logo=PyCharm&logoColor=white" /></a>  
  </p>
  </ul>
</div>

<h4 align="justify"> 
Statistical Aesthetics is a curated collection of data visualizations that replicate the color palettes and themes of world-famous paintings. This project explores the intersection of art, history, and data science, using meaningful datasets to create beautiful and insightful "data art." The goal of this ongoing project is to re-imagine classic art through the lens of data. Each visualization is an attempt to find a harmonious blend where the chosen dataset thematically resonates with the masterpiece it seeks to emulate.
</h4>
<br>

## On Exhibition ##

### The Mandate of Time: Reign Lengths of Chinese Emperors
This work visualizes the reign lengths of Chinese emperors across dynasties from Xia to Qing. Using R's `ggridges` package, it creates a a ridgeline plot showing the distribution of the length of reign for rulers in all dynasties of imperial China, styled with the iconic blue-green palette of Wang Ximeng's *A Thousand Li of Rivers and Mountains* (千里江山图).

<p align="center">
<img src="https://github.com/Weihua-Zhao97/Statistical_Aesthetics/blob/main/Wang%20Ximeng%3A%20Thousand%20Miles%20of%20Mountains%20and%20Rivers/Plot.jpeg"  />
</p>

- **Data:** Historical records of the reign lengths of 537 Chinese emperors from Xia dynasty to Qing dynasty
- **Data Source:** Wikipedia
- **Tool:** @R `ggplot2` | `ggridges` (Gaussian kernel)
- **Inspiration:** [《千里江山图》](https://www.dailyartmagazine.com/one-thousand-li-of-rivers-and-mountains/) by Wang Ximeng (CN, 1096–1119, Northern Song Dynasty), click below to explore the painting in its entirety.
<p align="center">
<img src="https://www.comuseum.com/wp-content/uploads/2015/11/wang-ximeng_rivers-and-mountains.jpg" width="1000"  />
</p>
<br>

### The Pond of Trade War: Global Market Volatility Under a Monet Palette
This visualization frames major global stock markets (US, CA, EU, UK, CN, JP) during Trump's trade war as an impressionist landscape: the x-axis corresponds to the day of the month and the y-axis lists the months in chronological order; each cell represents the market volatility, measured by absolute percentage log-returns. The plot maps the serene greens, violets, and pinks of Claude Monet's Water Lilies series onto financial turbulence due to geopolitical tension and uncertainty, potraiting a deceptively harmonious pond. 
<p align="center">
<img src="https://github.com/Weihua-Zhao97/Statistical_Aesthetics/blob/main/Claude%20Monet%3A%20water%20lilies/plot.jpeg"  />
</p>

- **Data:** Representative market indices (for six economies: US, CA, EU, UK, CN, JP) from Sep 30, 2024 to Sep 22, 2025
- **Data Source:** Yahoo Finance
- **Tool:** @R `ggplot2`
- **Inspiration:** [Water Lilies](https://www.metmuseum.org/art/collection/search/438008) by Claude Monet (FR, 1840-1926)

## Future Work ##

Planned pieces include:
- Replicating Xu Wei (徐渭, CN, 1521-1593, Ming Dynasty)'s *Peonies* with the combination of chord diagram and hierarchical edge bundling.
- Replicating Claude Monet (FR, 1840-1926)'s *Water Lilies* with heatmaps.

## Contributing ##

Suggestions and comments are welcome and appreciated. Stay tuned for more updates.
