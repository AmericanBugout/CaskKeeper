# CaskKeeper

#### - Release 2.0.1 -

* Ability to import your whiskey collection with a CSV file.
* Take backups of your collection by exporting to JSON on your device.
* Import a backup with JSON.
* Now tracks the price of a bottle.
* A toggle to turn off image icons.
* Keep track of your sealed, opened, and finished bottles.
* Small UI visual updates.

### CSV Import Usage

#### Example CSV. Headers and values should be comma separated.

| label   | bottle         | style   | bottleState | origin        | finish | proof | age | purchasedDate | dateOpened | locationPurchased | price |
|---------|----------------|---------|--------------|---------------|--------|-------|-----|---------------|-------------|--------------------|-------|
| Generic | 12 Year CS     | Bourbon | Open         | United States |        | 90    | 10  | 11/16/2023    | 11/17/2023  | Dollar             | 45.99 |


##### Optional Values
#### finish, age, purchasedDate, dateOpened, locationPurchased, price
If you don't have values to enter for these optional fields, simply leave the value as blank.

##### Certain headers need exact values.
style - Bourbon Irish Scotch Rye Japanese Tennessee Canadian <br>
bottleState - Sealed Open Finished <br>
origin - Scotland United Stated Ireland Canada Japan England <br>
purchasedData - mm/dd/yyyy OR m/d/yyyy <br>
dateOpened - mm/dd/yyyy or m/d/yyyy <br>
proof - Whole number or decimal 2 places <br>
age - Whole number or decimal 1 place <br>
price - price format with or without the dollar sign. No commas. <br>

