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