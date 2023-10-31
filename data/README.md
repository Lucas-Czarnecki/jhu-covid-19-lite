# Cleaned Daily Reports from JHU

This folder contains cleaned daily reports from CSSE JHU. Unlike CSSE JHU's raw csv files, every file in this folder consists of the same variables. 

**A record of changes is recorded below.**

### **Variable Names**

The following columns are found in every csv file in this order:

1. Date_Published
2. FIPS                
2. Admin2             
3. Province_State      
4. Country_Region      
5. Last_Updated         
6. Latitude            
7. Longitude                    
8. Confirmed 
9. Deaths 
10. Recovered 
11. Active            
12. Combined_Key    

### **How the data differ from JHU:**

* `Last_Update` fixes inconsistencies in how dates and times were formatted across csv files. 
     * All timestamps adopt a YYYY-MM-DD HH:MM:SS (24 hour format, in UTC) POSIXct format.
* Blank cells indicating an absence of COVID-19 `Confirmed`, `Deaths`, and `Recovered` cases are replace with zeros. (Preventing programs like R from treating these as missing values). 

* `Active` cases (i.e., Active = Confirmed - Deaths - Recoveries) are recalculated to correct for errors and to replace missing values in older daily reports. A sanity check also ensures that active cases are equal to or greater than zero; cases where JHU reports negative active cases are reported as missing values.

* A consistent naming scheme is enforced in `Country_Region` and `Province_State` to uniquely identify geographical locations across daily reports and time series data. For example, "Korea, South", and "Republic of Korea" are reduced to "South Korea" across all files. Other values such as "US" are changed to "United States" to improve data exploration and enforce a consistent naming scheme (e.g., "United States" and "United Kingdom" rather than "US" and "United Kingdom").

* Values in `Combined_Key` were recreated each day based on relevent string values. Creating a new `Combined_Key` addressed various inconsistencies across daily reports (e.g., "France" and ",,France") as well as issues that occur as a result of typos (see: [#2603](https://github.com/CSSEGISandData/COVID-19/issues/2603)).

* Fixes inconsistencies found in older daily reports where string values in `Province_State` combined the names of cities/counties with provinces/states (e.g., "Los Angeles, CA" and "Calgary, AB"). Such characters are split into `Admin2` (e.g., "Los Angeles) and `Province_State` (e.g., California). See [#2](https://github.com/Lucas-Czarnecki/COVID-19-CLEANED-JHUCSSE/issues/2) for more information. 

* Data from JHU's **Lookup Table** are mapped to daily reports to better ensure consistent naming conventions and data accuracy for `FIPS` geographical codes as well as `Latitude` and `Longitude` coordinates. Mapping these data also updates missing values in older daily reports and ensures consistency across all files. Any changes that JHU makes to their Lookup Table were automatically applied to all files in this repository with each update.

* `FIPS` codes are fixed to address known issues pertaining to JHU truncating leading zeros (e.g., [#2638](https://github.com/CSSEGISandData/COVID-19/issues/2638) and [#2530](https://github.com/CSSEGISandData/COVID-19/issues/2530)). `FIPS` values in this repo are corrected to 2 digits at the state-level and 5 digits at the county-level. 

