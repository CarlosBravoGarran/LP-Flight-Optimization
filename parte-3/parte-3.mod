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
param inicio{j in SLOTS};                # Hora de inicio de cada slot
param disponibilidad{j in SLOTS, p in PISTAS};  # Matriz de disponibilidad

# Subconjunto de slots válidos para cada avión
set SLOTS_VALIDOS{i in AVIONES} within SLOTS :=
    {j in SLOTS : inicio[j] >= llegada[i] and inicio[j] <= limite[i]};

# Variables de decisión de Parte 1: Tarifas
var x_billetes {TARIFAS, AVIONES} >= 0, integer;   # Número de billetes por tarifa por avión

# Variables de decisión de Parte 2: Aterrizaje
var x_aterrizaje {i in AVIONES, j in SLOTS, p in PISTAS}, binary;

# Función objetivo compuesta
# Maximiza el beneficio de billetes menos el coste de retraso
maximize Beneficio_Neto:
    sum {i in TARIFAS, j in AVIONES} precio[i] * x_billetes[i, j]
    - sum{i in AVIONES, j in SLOTS_VALIDOS[i], p in PISTAS} coste[i] * max(0, inicio[j] - llegada[i]) * x_aterrizaje[i, j, p];

# Restricciones de Parte 1: Capacidad y Mínimos de Tarifas
# Restricción 1: No exceder el número de asientos por avión
s.t. Max_Asientos {j in AVIONES}:
    sum {i in TARIFAS} x_billetes[i, j] <= capacidad_asientos[j];

# Restricción 2: No exceder la capacidad de peso por avión
s.t. Max_Peso {j in AVIONES}:
    sum {i in TARIFAS} peso[i] * x_billetes[i, j] <= capacidad_peso[j];

# Restricción 3: Mínimo 20 billetes de leisure por avión
s.t. Min_Leisure {j in AVIONES}:
    x_billetes['leisure', j] >= 20;

# Restricción 4: Mínimo 10 billetes de business por avión
s.t. Min_Business {j in AVIONES}:
    x_billetes['business', j] >= 10;

# Restricción 5: Al menos el 60% de los billetes deben ser de tarifa estándar
s.t. Min_Estandar:
    sum {j in AVIONES} x_billetes['estandar', j] >= 0.6 * sum {j in AVIONES, i in TARIFAS} x_billetes[i, j];

# Restricciones de Parte 2: Aterrizaje
# Restricción 6: Cada avión debe tener asignado un slot
s.t. Asignacion_Slot {i in AVIONES}:
    sum {j in SLOTS_VALIDOS[i], p in PISTAS} x_aterrizaje[i, j, p] = 1;

# Restricción 7: Un slot solo puede estar asignado a un avión
s.t. Slot_Unico {j in SLOTS, p in PISTAS}:
    sum {i in AVIONES} x_aterrizaje[i, j, p] <= 1;

# Restricción 8: Solo se asignan aviones a slots disponibles
s.t. Disponibilidad_Slot {i in AVIONES, j in SLOTS_VALIDOS[i], p in PISTAS}:
    x_aterrizaje[i, j, p] <= disponibilidad[j, p];

# Restricción 9: Restricción de consecutividad de slots para cada avión y pista
s.t. No_Aterr_Consec {i in AVIONES, j in SLOTS_VALIDOS[i], p in PISTAS: j < 6}:
    x_aterrizaje[i, j, p] + x_aterrizaje[i, j+1, p] <= 1;

end;
