/// obj_controller - Create Event
// Sistema de Mapa e Grade - Issue #1

// Configurações da grade
global.cell_size = 32;          // Tamanho de cada célula em pixels
global.map_width = 128;         // Largura do mapa em células
global.map_height = 128;        // Altura do mapa em células

// Criar grid principal do mapa
global.map_grid = ds_grid_create(global.map_width, global.map_height);
ds_grid_clear(global.map_grid, 0); // 0 = célula vazia

// Grid auxiliar para referências de objetos/edifícios
global.building_grid = ds_grid_create(global.map_width, global.map_height);
ds_grid_clear(global.building_grid, noone);

// Variáveis de controle
global.game_speed = 1;          // Velocidade do jogo (1=normal, 2=rápido, 0=pausado)

// Debug
show_debug_message("Sistema de Grade inicializado: " + string(global.map_width) + "x" + string(global.map_height));

// === Sistema de Construção de Estradas ===
global.tool_mode = 0;           // 0=nenhum, 1=estrada, 2=zona, etc
global.road_type = 1;           // 1=terra, 2=asfalto, 3=avenida
global.is_dragging = false;     // Se está arrastando para construir
global.drag_start_x = -1;       // Posição inicial do drag
global.drag_start_y = -1;

// Custos por tipo de estrada
global.road_cost = [0, 10, 50, 200]; // índice 0 não usado, 1=terra, 2=asfalto, 3=avenida

// Dinheiro inicial do jogador
global.money = 50000;

show_debug_message("Sistema de estradas inicializado");