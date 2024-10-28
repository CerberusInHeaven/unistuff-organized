import csv
vencedores = []

with open("winners.csv", mode="r") as arq:
    dados_csv = csv.DictReader(arq)
    for linha in dados_csv:
        vencedores.append(linha)


def titulo(texto):
    print()
    print(texto)
    print("-"*40)


def top10():
    # nome e número de vitórias dos 10 pilotos mais vitoriosos
    titulo("Top 10 Pilotos com Maior Número de Vitórias")
    pilotos = list(set([x['Winner'] for x in vencedores]))
    vitorias = [0] * len(pilotos)

    for vencedor in vencedores:
        indice = pilotos.index(vencedor['Winner'])
        vitorias[indice] += 1

    juntos = sorted(zip(vitorias, pilotos), reverse=True)

    print("Nº Nome do Piloto........... Vitórias")
    print("-------------------------------------")

    for num, (vitoria, piloto) in enumerate(juntos, start=1):
        print(f"{num:2d} {piloto:25s} {vitoria:5d}")
        if num == 10:
            break


def novos():
    # nome dos pilotos que venceram nos últimos 3 anos e
    # nunca tinham vencido antes
    titulo("Novos Pilotos Vencedores: Últimos 3 anos")
    pilotos3ult = set([x['Winner'] for x in vencedores if int(x['Date'][0:4]) >= 2022])
    pilotos3ant = set([x['Winner'] for x in vencedores if int(x['Date'][0:4]) < 2022])
    so3ult = pilotos3ult.difference(pilotos3ant)
    em_ordem = sorted(list(so3ult))
    print(f"Pilotos: {", ".join(em_ordem)}")


def remanescentes():
    # nome dos pilotos que venceram nos últimos 3 anos e
    # já haviam vencido anteriormente
    titulo("Pilotos Vencedores Remanescentes: Últimos 3 anos")
    pilotos3ult = set([x['Winner'] for x in vencedores if int(x['Date'][0:4]) >= 2022])
    pilotos3ant = set([x['Winner'] for x in vencedores if int(x['Date'][0:4]) < 2022])
    comuns = pilotos3ult.intersection(pilotos3ant)
    em_ordem = sorted(list(comuns))
    print(f"Pilotos: {", ".join(em_ordem)}")


def pesquisa():
    # pesquisa por nome(parte do nome) e mostrar as vitórias do piloto
    # (indicar caso o nome não conste)
    titulo("Pesquisa Pilotp")
    piloto = input("Nome do Piloto: ").upper()

    print("\nGrande Prêmio....... Data...... Equipe.............")
    print("---------------------------------------------------")

    vitorias = 0
    for vencedor in vencedores:
        if piloto in vencedor['Winner'].upper():
            print(f"{vencedor['Grand Prix']:20s} {vencedor['Date']} {vencedor['Car']}")
            vitorias += 1

    if vitorias == 0:
        print(f"*Obs.: Não há vitórias do piloto {piloto}")
    else:
        print("-"*50)
        print(f"{piloto} venceu: {vitorias} corridas")


# ------------------------------- Programa Principal
while True:
    titulo("Vencedores da Fórmula 1: Análise dos Dados")
    print("1. Top 10 Pilotos")
    print("2. Novos vencedores dos últimos 3 anos")
    print("3. Vencedores remanescentes dos últimos 3 anos")
    print("4. Pesquisar piloto")
    print("5. Finalizar")
    opcao = int(input("Opção: "))
    if opcao == 1:
        top10()
    elif opcao == 2:
        novos()
    elif opcao == 3:
        remanescentes()
    elif opcao == 4:
        pesquisa()
    else:
        break
