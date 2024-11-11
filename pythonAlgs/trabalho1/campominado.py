import random

# Cria o campo minado 

def inicializar_campo(tamanho, num_minas):
    campo = [[' ' for _ in range(tamanho)] for _ in range(tamanho)]
    minas_colocadas = 0
    
    # Coloca as minas em posições randomicas (que diversãã~~aaoooo)
    while minas_colocadas < num_minas:
        x, y = random.randint(0, tamanho - 1), random.randint(0, tamanho - 1)
        if campo[x][y] != '*':
            campo[x][y] = '*'
            minas_colocadas += 1
            
    return campo
#
#
#
#
# exibe o campo (só células reveladas)
def mostrar_campo(campo, reveladas):
    for i in range(len(campo)):
        linha = ''
        for j in range(len(campo[i])):
            if reveladas[i][j]:
                linha += campo[i][j] + ' '
            else:
                linha += '_ '
        print(linha)
#
#
#
#
#
# conta as minas no campo minado 
def contar_minas(campo, x, y):
    tamanho = len(campo)
    minas = 0
    for i in range(max(0, x - 1), min(tamanho, x + 2)):
        for j in range(max(0, y - 1), min(tamanho, y + 2)):
            if campo[i][j] == '*':
                minas += 1
    return minas

# inicializa essa bagaça inteira
def jogar():
    tamanho = 5 
    num_minas = 5
    campo = inicializar_campo(tamanho, num_minas)
    reveladas = [[False for _ in range(tamanho)] for _ in range(tamanho)]
    pontuacao = 0
    jogador = input("Digite seu nome: ")
    
    while True:
        mostrar_campo(campo, reveladas)
        x = int(input("Escolha a linha (0 a 4): "))
        y = int(input("Escolha a coluna (0 a 4): "))
        
        # sentou na minna kkkkkkkk
        if campo[x][y] == '*':
            print("Game Over! Você encontrou uma mina.")
            break
        
        # Revela o campo e calcula pontos
        if not reveladas[x][y]:
            reveladas[x][y] = True
            minas_adjacentes = contar_minas(campo, x, y)
            campo[x][y] = str(minas_adjacentes)
            pontuacao += 1
            
            # estatisticamente isso não acontece.... mas se por algum motivo alguém ganhar essa bagaça, verifica a win condition
            if pontuacao == (tamanho * tamanho - num_minas):
                print("Parabéns! Você venceu o jogo!")
                break
    
    print(f"Pontuação: {pontuacao}")
    salvar_pontuacao(jogador, pontuacao)
    exibir_ranking()

# salva pontuação em um txt bagaceiro 
def salvar_pontuacao(jogador, pontuacao):
    with open("ranking.txt", "a") as arquivo:
        arquivo.write(f"{jogador} - {pontuacao}\n")

# exibe o ranqueamento 
def exibir_ranking():
    print("\nRanking dos Jogadores:")
    try:
        with open("ranking.txt", "r") as arquivo:
            for linha in arquivo:
                print(linha.strip())
    except FileNotFoundError:
        print("Nenhum ranking encontrado.")

jogar()
