# Visão Técnica - Cities (GameMaker Studio 2)

## Arquitetura Geral

### Estrutura de Dados Principal

```gml
// Grid principal do mapa
global.map_grid = ds_grid_create(128, 128);

// Valores possíveis por célula:
// 0 = vazio
// 1 = estrada (rua de terra)
// 2 = estrada (asfalto)
// 3 = estrada (avenida)
// 4 = zona residencial baixa
// 5 = zona residencial média
// 6 = zona residencial alta
// 7 = zona comercial baixa
// 8 = zona comercial alta
// 9 = zona industrial leve
// 10 = zona industrial pesada
// 100+ = edificações/serviços
```

### Sistema de Objetos

#### Objetos Principais
- `obj_controller`: Gerenciador global do jogo
- `obj_camera`: Controle de câmera e zoom
- `obj_cell`: Célula individual da grade (tile)
- `obj_road`: Representação de estradas
- `obj_building`: Classe base para edifícios
- `obj_zone`: Marcador de zona
- `obj_vehicle`: Veículos para simulação de trânsito
- `obj_ui_manager`: Gerenciador de interface

#### Hierarquia de Edifícios
```
obj_building (parent)
├── obj_building_residential
├── obj_building_commercial
├── obj_building_industrial
└── obj_building_service
    ├── obj_powerplant
    ├── obj_police_station
    ├── obj_fire_station
    └── obj_hospital
```

## Sistemas Principais

### 1. Sistema de Grade e Mapa

```gml
// Inicialização no obj_controller Create Event
global.cell_size = 32; // pixels por célula
global.map_width = 128;
global.map_height = 128;
global.map_grid = ds_grid_create(global.map_width, global.map_height);
ds_grid_clear(global.map_grid, 0);

// Grid auxiliar para edificações (referências de instâncias)
global.building_grid = ds_grid_create(global.map_width, global.map_height);
ds_grid_clear(global.building_grid, noone);
```

### 2. Sistema de Construção de Estradas

```gml
// No obj_controller Step Event (quando ferramenta de estrada ativa)
if (tool_mode == TOOL_ROAD) {
    var grid_x = floor(mouse_x / global.cell_size);
    var grid_y = floor(mouse_y / global.cell_size);
    
    if (mouse_check_button(mb_left) && in_bounds(grid_x, grid_y)) {
        if (global.money >= road_cost[road_type]) {
            ds_grid_set(global.map_grid, grid_x, grid_y, road_type);
            global.money -= road_cost[road_type];
            // Criar sprite visual
            instance_create_layer(grid_x * global.cell_size, 
                                 grid_y * global.cell_size, 
                                 "Roads", obj_road);
        }
    }
}
```

### 3. Sistema de Zoneamento

```gml
// Crescimento automático de zonas (Step Event com alarm)
if (alarm[0] <= 0) {
    alarm[0] = room_speed * 5; // A cada 5 segundos
    
    // Verificar demanda
    if (demand_residential > 0) {
        // Procurar células zoneadas vazias
        for (var i = 0; i < global.map_width; i++) {
            for (var j = 0; j < global.map_height; j++) {
                var cell_type = ds_grid_get(global.map_grid, i, j);
                if (cell_type >= 4 && cell_type <= 6) { // zona residencial
                    if (ds_grid_get(global.building_grid, i, j) == noone) {
                        if (is_adjacent_to_road(i, j)) {
                            // Criar edifício
                            var building = instance_create_layer(
                                i * global.cell_size, 
                                j * global.cell_size, 
                                "Buildings", 
                                obj_building_residential
                            );
                            ds_grid_set(global.building_grid, i, j, building);
                            demand_residential -= 1;
                            break;
                        }
                    }
                }
            }
        }
    }
}
```

### 4. Sistema de Rede Elétrica

```gml
// Propagação de eletricidade usando BFS (Breadth-First Search)
function propagate_electricity() {
    // Grid temporário para marcar células com energia
    var power_grid = ds_grid_create(global.map_width, global.map_height);
    ds_grid_clear(power_grid, false);
    
    // Fila para BFS
    var queue = ds_list_create();
    
    // Adicionar todas usinas à fila
    with (obj_powerplant) {
        var gx = floor(x / global.cell_size);
        var gy = floor(y / global.cell_size);
        ds_list_add(queue, [gx, gy]);
        ds_grid_set(power_grid, gx, gy, true);
    }
    
    // BFS para propagar
    while (ds_list_size(queue) > 0) {
        var pos = queue[| 0];
        ds_list_delete(queue, 0);
        
        var cx = pos[0];
        var cy = pos[1];
        
        // Verificar vizinhos (células com postes/linhas)
        for (var dx = -1; dx <= 1; dx++) {
            for (var dy = -1; dy <= 1; dy++) {
                if (abs(dx) + abs(dy) != 1) continue; // apenas adjacentes
                var nx = cx + dx;
                var ny = cy + dy;
                
                if (in_bounds(nx, ny) && !ds_grid_get(power_grid, nx, ny)) {
                    if (has_power_line(nx, ny)) {
                        ds_grid_set(power_grid, nx, ny, true);
                        ds_list_add(queue, [nx, ny]);
                    }
                }
            }
        }
    }
    
    ds_list_destroy(queue);
    return power_grid;
}
```

### 5. Sistema de Trânsito

```gml
// Pathfinding com mp_grid
global.traffic_grid = mp_grid_create(0, 0, global.map_width, global.map_height, 
                                     global.cell_size, global.cell_size);

// Atualizar grid de pathfinding quando estradas mudam
function update_traffic_grid() {
    mp_grid_clear_all(global.traffic_grid);
    
    // Marcar células sem estrada como bloqueadas
    for (var i = 0; i < global.map_width; i++) {
        for (var j = 0; j < global.map_height; j++) {
            var cell = ds_grid_get(global.map_grid, i, j);
            if (cell < 1 || cell > 3) { // não é estrada
                mp_grid_add_cell(global.traffic_grid, i, j);
            }
        }
    }
}

// Veículos usam pathfinding
// No obj_vehicle Create Event
path = path_add();
target_x = irandom(global.map_width - 1) * global.cell_size;
target_y = irandom(global.map_height - 1) * global.cell_size;

if (mp_grid_path(global.traffic_grid, path, x, y, target_x, target_y, false)) {
    path_start(path, vehicle_speed, path_action_stop, false);
}
```

### 6. Sistema de Câmera

```gml
// No obj_camera Step Event
if (mouse_check_button(mb_middle)) {
    camera_x -= (mouse_x - mouse_previous_x) / zoom_level;
    camera_y -= (mouse_y - mouse_previous_y) / zoom_level;
}

// Zoom
if (mouse_wheel_up()) {
    zoom_level = clamp(zoom_level * 1.1, 0.5, 3.0);
}
if (mouse_wheel_down()) {
    zoom_level = clamp(zoom_level * 0.9, 0.5, 3.0);
}

// Aplicar transformação da câmera
var cam = view_camera[0];
view_set_xport(0, camera_x);
view_set_yport(0, camera_y);
view_set_wport(0, view_wport[0] / zoom_level);
view_set_hport(0, view_hport[0] / zoom_level);
```

### 7. Interface e Modos de Visualização

```gml
// Overlay de visualização usando shaders ou draw events
// No Draw Event de obj_ui_manager

if (view_mode == VIEW_POLLUTION) {
    shader_set(shd_heatmap);
    
    for (var i = 0; i < global.map_width; i++) {
        for (var j = 0; j < global.map_height; j++) {
            var pollution = get_pollution_at(i, j);
            var color = make_color_hsv(0, 0, pollution * 255);
            draw_set_alpha(0.5);
            draw_rectangle_color(
                i * global.cell_size, j * global.cell_size,
                (i+1) * global.cell_size, (j+1) * global.cell_size,
                color, color, color, color, false
            );
        }
    }
    
    shader_reset();
    draw_set_alpha(1.0);
}
```

### 8. Sistema de Salvamento

```gml
// Salvar jogo
function save_game(slot) {
    var save_data = {
        map: ds_grid_to_array(global.map_grid),
        money: global.money,
        population: global.population,
        date: current_time,
        // ... outros dados
    };
    
    var json = json_stringify(save_data);
    var file = file_text_open_write("save_" + string(slot) + ".sav");
    file_text_write_string(file, json);
    file_text_close(file);
}

// Carregar jogo
function load_game(slot) {
    if (file_exists("save_" + string(slot) + ".sav")) {
        var file = file_text_open_read("save_" + string(slot) + ".sav");
        var json = file_text_read_string(file);
        file_text_close(file);
        
        var save_data = json_parse(json);
        
        // Restaurar grid
        ds_grid_destroy(global.map_grid);
        global.map_grid = array_to_ds_grid(save_data.map);
        global.money = save_data.money;
        // ... restaurar outros dados
    }
}
```

## Otimizações

### Performance
- Usar `ds_grid` em vez de arrays 2D para acesso rápido
- Limitar updates de demanda/crescimento a intervalos (ex: 5 segundos)
- Culling de objetos fora da câmera
- Pooling de objetos de veículos

### Memória
- Destruir `ds_grid` e `ds_list` quando não usados
- Usar sprites compartilhados para edifícios similares
- Comprimir dados de salvamento

## Estrutura de Pastas Sugerida

```
Cities/
├── sprites/
│   ├── spr_road_dirt/
│   ├── spr_road_asphalt/
│   ├── spr_building_residential_*/
│   └── spr_ui_*/
├── objects/
│   ├── obj_controller/
│   ├── obj_camera/
│   ├── obj_cell/
│   └── obj_building_*/
├── scripts/
│   ├── scr_grid_utils/
│   ├── scr_pathfinding/
│   ├── scr_economy/
│   └── scr_save_load/
├── rooms/
│   └── rm_game/
└── shaders/
    └── shd_heatmap/
```

## Próximos Passos

1. Implementar grid básico e visualização
2. Sistema de construção de estradas
3. Câmera funcional
4. Zoneamento e crescimento
5. Rede elétrica
6. Interface completa
7. Salvamento
8. Polimento e otimização