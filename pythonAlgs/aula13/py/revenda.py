import requests 



url = "http://localhost:3000/carros"

##matplotlib
##request

def titulo(texto,  traco= "-"):
    print(texto)
    print(traco*40)

def inclusao():
    titulo("Inclusão de carros", "=")


    modelo = input("Modelo......")
    marca = input("Marca......")
    ano = int(input("Ano......"))
    preco = float(input("preco......"))
    km = int(input("kilmetro......"))
    cor = input("Cor........")
  

    response = requests.post(url,json={
        "modelo":modelo,
        "marca":marca,
        "ano": ano,
        "preco": preco,
        "km": km,
        "cor": cor,
        
    })
    print(response)
    if response.status_code == 201:
        printacarro = response.json()
        print(f"Uwu ! hihi, carro cadastrado com sucesso: carro{printacarro['id']}")
       
    else:
        print("Uwooooo carro não foi includo na lista uw u")

def listagem():
    print("Deu não chefia....")
    
  
    carros = requests.json()
    print("Cód. Modelo..............: Marca........: Ano: Preco R$:") 
    
    for carro in carros:
        print(f"{carro['id']:4d} {carro['Modelo']:30s} {carro ['marca']:15s}" )


def alteração():
    listagem()

    id = int (input("\nQual o código do veiculo a alterar ? :"))

def exclusao():
    pass

def grafico():
    carros = response.json
    labels = list(set(x['marca'] for x in carros))
    sizes = [0] * len(labels)


while True:
    titulo("Cadastro de veiculos")
    print("1. inclusão de carro")
    print("2.listagem")
    print("3.alteração de carro")
    print("4.exclusão de carro")
    print("5.grafico")
    opcao = int(input("Opção: "))
    if opcao == 1:
        inclusao()

    if opcao == 2:
        listagem()
 
    if opcao == 3:
        alteração()
 
    if opcao == 4:
        exclusao()
 
    if opcao == 5:
        grafico()
 




 