import csv 
visistantes = []

with open("visitantes.csv", mode="r") as arq:
    datacsv = csv.DictReader(arq)
    for linha in datacsv:
        visistantes.append(linha)

def titulo(texto):
    print()
    print(texto)
    print("*"*40)



def top10_paises():
    titulo("TOP 10 PAISES COM N VISITANTES")
    paises = list(set([x['Country'] for x in visistantes]))
    numeros = [0] * len(paises)

    for visitors in visistantes:
        indice = paises.index(visitors['Country'])
        numeros[indice] += int(visitors['Visitor'])

    togethaaarrr = sorted(zip(numeros, paises), reverse=True)

    print("Nª pais ........... visitantes")
    print(".........................................")

    for i, (num, pais) in enumerate(togethaaarrr, start=1):
        print(f"{i:2d} {pais:20s} {num:10d}")
        if i == 10:
            break

def bigmonths():
    titulo("top 10 meses mais safados já criados")

    visistantes2 = sorted(visistantes, key=lambda visitante: int(visitante['Visitor']), reverse=True)
    
    print("Nª pais ........... Mês/Ano.: Visitantes")
    print(".........................................")

    for i, visistante in enumerate(visistantes2, start=1):
        print (f"{i:2d} {visistante['Country']:20s} {visistante['Month']:4s}/{visistante['Year']:4s} {int(visistante['Visitor']):10d}")
        if i == 10:
            break

def compara_meses():
    titulo("Comparar Total de visistante em 2 meses")
    mes1 = input("1ª Mês: ").upper()
    mes2 = input("2ª Mês: ").upper()
    total1 = 0 
    total2 = 0
    
    for visita in visistantes:
        if visita['Month'].upper() == mes1:
            total1 += int(visita['Visitor'])

        elif visita['Month'].upper() == mes2:
             total2 += int(visita['Visitor'])

    print(f"Total {mes1}: {total1: 10d}")
    print(f"Total {mes2}: {total2: 10d}")


def pesquisaano():
    titulo("Pesquisa Pais e Ano")
    pais = input("Pais.: ").upper()
    ano = int(input("Ano..: "))

    print("\nMês. Visitantes")
    print("***************************")

    total = 0
    for visita in visistantes:
        if pais == visita['Country'].upper() and ano == int(visita['Year']):
            print(f"{visita['Month']:4s} {int(visita['Visitor']):10d}")
            total += int(visita['Visitor'])

    if total == 0:
        print(f"obs.: não há visitantes nigga {pais}, no ano {ano}")
    else:
        print("-"*50)
        print(f"Total: {total} Visitantes")



def compara_2017_2023():
    titulo("TOP 10 PAISES DE 2017")


    visitantes17 = [x for x in visistantes if int(x['Year']) ==2017]
    paises17 = list(set([x['Country'] for x in visitantes17]))
    numeros17 = [0] * len(paises17)
    top17 = []

    for visita in visitantes17:
        indice = paises17.index(visita['Country'])
        numeros17[indice] += int(visita['Visitor'])


    juntos = sorted(zip(numeros17, paises17), reverse=True)

    print("Top 10 - 2017")
    print("Nª Pais ................... Visitantes")
    print("......................................")
    
    for i, (num, pais) in enumerate(juntos, start=1):
        print(f"{i:2d} {pais:20s} {num:10d}")
        top17.append(pais)
        if i == 10:
            break
#---------------------------------------------------------#

    visitantes23 = [x for x in visistantes if int(x['Year']) ==2023]
    paises23 = list(set([x['Country'] for x in visitantes23]))
    numeros23 = [0] * len(paises23)
    top23 = []

    for visita23 in visitantes23:
        indice = paises23.index(visita23['Country'])
        numeros23[indice] += int(visita23['Visitor'])


    juntin23 = sorted(zip(numeros23, paises23), reverse=True)

    print("Top 10 - 2023")
    print("Nª Pais ................... Visitantes")
    print("......................................")
    
    for i, (num23, pais23) in enumerate(juntin23, start=1):
        print(f"{i:2d} {pais23:20s} {num23:10d}")
        top23.append(pais23)
        if i == 10:
            break


    comuns = set(top17).intersection(set(top23))
    novos = set(top23).difference(set(top17))

    print(f"\n Comuns 2017 e 2023: {", ".join(comuns)}")
    print(f"\n Comuns 2017 e 2023: {", ".join(novos)}")



while True: 
    titulo("Passageiros do titanic: Exemplos de analise")
    titulo("1, teste1")
    titulo("2, teste2")
    titulo("3, teste3")
    titulo("4, teste4")
    titulo("5, teste5")
    opcao = int(input("Opção: "))
    if opcao == 1:
        top10_paises()
    elif opcao == 2:
        bigmonths()
    elif opcao == 3:
        compara_meses()

    elif opcao == 4:
        pesquisaano()
    elif opcao == 5:
        compara_2017_2023()
    else:
        break
