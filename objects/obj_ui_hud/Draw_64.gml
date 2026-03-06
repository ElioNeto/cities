// Desenha interface do usuário

draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Fundo semi-transparente para o HUD
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_rectangle(10, 10, 300, 150, false);
draw_set_alpha(1.0);

// Informações do jogador
draw_set_color(c_white);
draw_text(20, 20, "Dinheiro: $" + string(global.money));

// Modo de ferramenta
var tool_text = "Ferramenta: ";
switch(global.tool_mode) {
    case 0: tool_text += "Nenhuma (pressione R)"; break;
    case 1: tool_text += "ESTRADA"; break;
}
draw_text(20, 50, tool_text);

// Se ferramenta de estrada ativa, mostrar tipo
if (global.tool_mode == 1) {
    var road_text = "Tipo de Estrada: ";
    var cost = global.road_cost[global.road_type];
    switch(global.road_type) {
        case 1: road_text += "Terra ($" + string(cost) + ") [1]"; break;
        case 2: road_text += "Asfalto ($" + string(cost) + ") [2]"; break;
        case 3: road_text += "Avenida ($" + string(cost) + ") [3]"; break;
    }
    draw_text(20, 80, road_text);
    draw_text(20, 110, "Clique e arraste para construir");
}

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);