# Conjuntos
set AVIONES;
set TARIFAS;
set SLOTS;
set PISTAS;

# Parámetros de Parte 1: Tarifas y Capacidad
param precio {TARIFAS};                  # Precio de cada tipo de tarifa
param peso {TARIFAS};                    # Peso del equipaje permitido para cada tipo de tarifa
param capacidad_asientos {AVIONES};      # Capacidad de asientos para cada avión
param capacidad_peso {AVIONES};          # Capacidad de peso para cada avión

# Parámetros de Parte 2: Coste de Retraso y Disponibilidad de Slots
param coste{i in AVIONES};               # Coste de retraso por minuto para cada avión
param llegada{i in AVIONES};             # Hora de llegada programada
param limite{i in AVIONES};              # Hora límite de aterrizaje
param inicio{s in SLOTS};                # Hora de inicio de cada slot
param disponibilidad{s in SLOTS, k in PISTAS};  # Matriz de disponibilidad

# Subconjunto de slots válidos para cada avión
set SLOTS_VALIDOS{i in AVIONES} within SLOTS :=
    {s in SLOTS : inicio[s] >= llegada[i] and inicio[s] <= limite[i]};

# Variables de decisión de Parte 1: Tarifas
var x {AVIONES, TARIFAS} >= 0, integer;   # Número de billetes por tarifa por avión

# Variables de decisión de Parte 2: Aterrizaje
var y {i in AVIONES, s in SLOTS, k in PISTAS}, binary;

# Función objetivo compuesta
# Maximiza el beneficio de billetes menos el coste de retraso
maximize Beneficio_Neto:
    sum {i in AVIONES, j in TARIFAS} precio[j] * x[i, j]
    - sum{i in AVIONES, s in SLOTS_VALIDOS[i], k in PISTAS} coste[i] * (inicio[s] - llegada[i]) * y[i, s, k];


# Restricciones de Parte 1: Capacidad y Mínimos de Tarifas

# Restricción 1: No exceder el número de asientos por avión
s.t. Max_Asientos {i in AVIONES}:
    sum {j in TARIFAS} x[i, j] <= capacidad_asientos[i];

# Restricción 2: No exceder la capacidad de peso por avión
s.t. Max_Peso {i in AVIONES}:
    sum {j in TARIFAS} peso[j] * x[i, j] <= capacidad_peso[i];

# Restricción 3: Mínimo 20 billetes de leisure por avión
s.t. Min_Leisure {i in AVIONES}:
    x[i, 'leisure'] >= 20;

# Restricción 4: Mínimo 10 billetes de business por avión
s.t. Min_Business {i in AVIONES}:
    x[i, 'business'] >= 10;

# Restricción 5: Al menos el 60% de los billetes deben ser de tarifa estándar
s.t. Min_Estandar:
    sum {i in AVIONES} x[i, 'estandar'] >= 0.6 * sum {i in AVIONES, j in TARIFAS} x[i, j];


# Restricciones de Parte 2: Aterrizaje

# Restricción 6: Cada avión debe tener asignado un slot
s.t. Asignacion_Slot {i in AVIONES}:
    sum {s in SLOTS_VALIDOS[i], k in PISTAS} y[i, s, k] = 1;

# Restricción 7: Un slot solo puede estar asignado a un avión
s.t. Slot_Unico {s in SLOTS, k in PISTAS}:
    sum {i in AVIONES} y[i, s, k] <= 1;

# Restricción 8: Solo se asignan aviones a slots disponibles
s.t. Disponibilidad_Slot {i in AVIONES, s in SLOTS_VALIDOS[i], k in PISTAS}:
    y[i, s, k] <= disponibilidad[s, k];

# Restricción 9: Restricción de consecutividad de slots para cada avión y pista
s.t. No_Aterr_Consec {i in AVIONES, s in SLOTS_VALIDOS[i], k in PISTAS: s < 6}:
    y[i, s, k] + y[i, s+1, k] <= 1;

end;
