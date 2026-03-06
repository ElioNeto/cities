// Desenha a célula

// Obter tipo atual da célula no grid
cell_type = get_cell_type(grid_x, grid_y);

// Desenhar baseado no tipo
switch(cell_type) {
    case 0: // Vazio
        draw_sprite(spr_ground_empty, 0, x, y);
        break;

    case 1: // Estrada de terra (implementar depois)
    case 2: // Asfalto
    case 3: // Avenida
        // Por enquanto, desenhar retângulo colorido
        draw_set_color(c_gray);
        draw_rectangle(x, y, x + global.cell_size, y + global.cell_size, false);
        break;

    default:
        // Tipo desconhecido, desenhar vermelho
        draw_set_color(c_red);
        draw_rectangle(x, y, x + global.cell_size, y + global.cell_size, false);
        break;
}

// Debug: desenhar borda da célula
draw_set_color(c_dkgray);
draw_set_alpha(0.2);
draw_rectangle(x, y, x + global.cell_size, y + global.cell_size, true);
draw_set_alpha(1.0);
draw_set_color(c_white);