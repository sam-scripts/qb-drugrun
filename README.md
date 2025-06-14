<h1>QB-Core Drug Running Script</h1>

<strong>Preview:</strong> google.com

<h4>Features</h4>

<ul>
    <li>Open Source</li>
    <li>Reputation System</li>
    <li>Indepth Config File</li>
</ul>

<h4>Installation</h4>

<ol>
  <li>Download the repository <a href="https://github.com/sam-scripts/qb-drugrun">here</a>.</li>
  <li>Extract the folder and upload it to your servers resource folder</li>
</ol>

<h4>Configuration File</h4>

```Config = {}

-- Ped Character
Config.Ped = "a_m_m_socenlat_01"

-- Delivery Peds
Config.LowRepDeliveryPeds = {
    "a_m_m_hillbilly_02",
    "a_m_m_salton_03",
    "a_m_m_afriamer_01",
    "a_m_m_tramp_01",
    "a_m_mtrampbeac",
    "a_m_y_beachvesp_0",
    "a_m_y_skater_01",
    "a_m_y_hipster_03"

}

Config.HighRepDeliveryPeds = {
    "a_f_y_business_01",
    "a_f_y_business_03",
    "a_m_m_soucent_02",
    "a_m_y_business_02"

}

-- Ped Coords
Config.PedCoords = vector4(-535.39, -1707.22, 19.54-1, 199.85) -- MAKE SURE TO MINUS THE Z VALUE BY 1

-- Target Message
Config.TargetMessage = "Talk to Miguel"

-- Car Model
Config.CarModel = "speedo"

Config.CarCoords = vector4(-519.62, -1705.25, 19.2, 218.46)

-- Delivery Item
Config.DeliveryItem = "suspiciouspackage"

-- Delivery Coords
Config.LowRepDeliveryCoords = {
    vector3(525.95, -1652.94, 29.32),
    vector3(709.31, -943.17, 24.25),
    vector3(-597.9, -1161.41, 22.32)
}


Config.HighRepDeliveryCoords = {
    vector3(-1131.56, 392.48, 70.82),
    vector3(-1470.15, 510.82, 117.67),
    vector3(-671.66, 299.85, 81.84)
}

-- Reputation Tiers
-- This is the value that will be took as a cutoff for the low and high rep, if a players reputation is higher than this they will be classed as "High Rep" if the reputation is lower than this number they will be classed as "Low Rep"

Config.RepThreshold = 25

-- The range at which rep will be given on each delivery completed, if you want a base number replace the field with the number you want
Config.RepGiveRange = math.random(5,10) 

-- Cash reward of low rep players
Config.LowRepReward = math.random(1000,5000)

-- Cash reward of low rep players
Config.HighRepReward = math.random(5000,10000)
```

<br>

If you are in need of any help please add me on discord and I will try as best as I can to respond fast (sam7870).
