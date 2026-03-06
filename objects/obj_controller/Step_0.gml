/// obj_controller - Step Event
// Atualização principal do jogo

// Controle de velocidade do tempo
if (global.game_speed == 0) {
    // Jogo pausado - não fazer nada
    exit;
}

// Aqui virão updates periódicos (demanda, crescimento, etc)