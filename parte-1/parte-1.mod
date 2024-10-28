# Definición de conjuntos
set AVIONES;          # Conjunto de aviones
set TARIFAS;          # Conjunto de tipos de tarifas

# Parámetros
param precio {TARIFAS};                 # Precio de cada tipo de tarifa
param peso {TARIFAS};                   # Peso del equipaje permitido para cada tipo de tarifa
param capacidad_asientos {AVIONES};     # Capacidad de asientos para cada avión
param capacidad_peso {AVIONES};         # Capacidad de peso para cada avión

# Variables de decisión
var x {AVIONES, TARIFAS} >= 0, integer;   # Número de billetes por tarifa por avión

# Función objetivo: maximizar el beneficio total
maximize Beneficio_Total:
    sum {i in AVIONES, j in TARIFAS} precio[j] * x[i,j];

# Restricción 1: No exceder el número de asientos por avión
s.t. Max_Asientos {i in AVIONES}:
    sum {j in TARIFAS} x[i,j] <= capacidad_asientos[i];

# Restricción 2: No exceder la capacidad de peso por avión
s.t. Max_Peso {i in AVIONES}:
    sum {j in TARIFAS} peso[j] * x[i,j] <= capacidad_peso[i];

# Restricción 3: Mínimo 20 billetes de leisure plus por avión
s.t. Min_Leisure_Plus {i in AVIONES}:
    x[i, 'leisure'] >= 20;

# Restricción 4: Mínimo 10 billetes de business plus por avión
s.t. Min_Business_Plus {i in AVIONES}:
    x[i, 'business'] >= 10;

# Restricción 5: Al menos el 60% de todos los billetes deben ser de estándar
s.t. Min_Estandar:
    sum {i in AVIONES} x[i, 'estandar'] >= 0.6 * sum {i in AVIONES, j in TARIFAS} x[i,j];

end;
