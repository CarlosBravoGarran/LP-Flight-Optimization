# Optimization of Fares and Aircraft Landing

## Description

This project is a **linear programming** practice focused on optimizing fares and managing aircraft landing through the use of modeling tools and mathematical solutions. The solution is proposed in three parts:

1. **Fare Optimization**: Maximizing profit by assigning fares to seats on each aircraft, considering weight capacities, seat limits, and minimum sales per fare.
2. **Landing Management**: Minimizing delay costs by allocating landing slots within the limits of arrival times and runway availability.
3. **Fused Model**: Combining the fare and landing models into a single model, optimizing both objective functions.

## Project Structure

- `part-1/`: Includes the basic modeling of the fare problem in LibreOffice Calc and its implementation in GLPK.
- `part-2/`: Development of the slot management and time restriction problem in GLPK.
- `part-3/`: A fused model that combines fare optimization and landing management into a single GLPK model.
- `data/`: `.dat` files containing the data used in each model.
- `models/`: `.mod` files defining the models in MathProg.
- `sol/`: Output files with the solutions obtained in GLPK.

## Installation and Requirements

To run the models, you will need:

- **GLPK** (GNU Linear Programming Kit)
- **LibreOffice Calc** (for the first part in Calc)
- **GLPSOL** (the GLPK solver) which can be run with the following command:

### Running Models in GLPK

To solve the model for any part, execute the following command in the terminal, adjusting the file names as needed:

```bash
glpsol -m part-X/parte-X.mod -d part-X/parte-X.dat -o part-X/parte-X.sol
```
