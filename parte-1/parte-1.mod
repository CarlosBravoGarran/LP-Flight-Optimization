# Definición de conjuntos
set AVIONES;          # Conjunto de aviones
set TARIFAS;          # Conjunto de tipos de tarifas

# Parámetros
param precio {TARIFAS};                 # Precio de cada tipo de tarifa
param peso {TARIFAS};                   # Peso del equipaje permitido para cada tipo de tarifa
param capacidad_asientos {AVIONES};     # Capacidad de asientos para cada avión
param capacidad_peso {AVIONES};         # Capacidad de peso para cada avión

# Variables de decisión
var x {TARIFAS, AVIONES} >= 0, integer;   # Número de billetes por tarifa por avión

# Función objetivo: maximizar el beneficio total
maximize Beneficio_Total:
    sum {i in TARIFAS, j in AVIONES} precio[i] * x[i,j];

# Restricción 1: No exceder el número de asientos por avión
s.t. Max_Asientos {j in AVIONES}:
    sum {i in TARIFAS} x[i,j] <= capacidad_asientos[j];

# Restricción 2: No exceder la capacidad de peso por avión
s.t. Max_Peso {j in AVIONES}:
    sum {i in TARIFAS} peso[i] * x[i,j] <= capacidad_peso[j];

# Restricción 3: Mínimo 20 billetes de leisure plus por avión
s.t. Min_Leisure_Plus {j in AVIONES}:
    x['leisure',j] >= 20;

# Restricción 4: Mínimo 10 billetes de business plus por avión
s.t. Min_Business_Plus {j in AVIONES}:
    x['business',j] >= 10;

# Restricción 5: Al menos el 60% de todos los billetes deben ser de estándar
s.t. Min_Estandar:
    sum {j in AVIONES} x['estandar',j] >= 0.6 * sum {j in AVIONES, i in TARIFAS} x[i,j];

end;
