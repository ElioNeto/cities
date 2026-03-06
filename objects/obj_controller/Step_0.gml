/// obj_controller - Step Event
// Atualização principal do jogo

// Controle de velocidade do tempo
if (global.game_speed == 0) {
    // Jogo pausado - não fazer nada
    exit;
}

// === Construção de Estradas ===
if (global.tool_mode == 1) { // Ferramenta de estrada ativa
    var grid_pos = get_mouse_grid_pos();
    var grid_x = grid_pos[0];
    var grid_y = grid_pos[1];

    // Iniciar drag
    if (mouse_check_button_pressed(mb_left) && in_bounds(grid_x, grid_y)) {
        global.is_dragging = true;
        global.drag_start_x = grid_x;
        global.drag_start_y = grid_y;
    }

    // Durante drag - construir estrada
    if (mouse_check_button(mb_left) && global.is_dragging && in_bounds(grid_x, grid_y)) {
        // Construir linha entre posição inicial e atual
        build_road_line(global.drag_start_x, global.drag_start_y, grid_x, grid_y, global.road_type);

        // Atualizar posição inicial para próximo frame (permite desenho contínuo)
        global.drag_start_x = grid_x;
        global.drag_start_y = grid_y;
    }

    // Soltar botão - finalizar drag
    if (mouse_check_button_released(mb_left)) {
        global.is_dragging = false;
    }

    // Trocar tipo de estrada com teclas 1, 2, 3
    if (keyboard_check_pressed(ord("1"))) global.road_type = 1; // Terra
    if (keyboard_check_pressed(ord("2"))) global.road_type = 2; // Asfalto
    if (keyboard_check_pressed(ord("3"))) global.road_type = 3; // Avenida
}

// Ativar/desativar ferramenta de estrada com tecla R
if (keyboard_check_pressed(ord("R"))) {
    global.tool_mode = (global.tool_mode == 1) ? 0 : 1;
    show_debug_message("Tool mode: " + (global.tool_mode == 1 ? "ROAD" : "NONE"));
}