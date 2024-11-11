import requests
import matplotlib.pyplot as plt

url = "http://localhost:3000/carros"

def inclusao():
  titulo("Inclusão de Carros", "=")

  modelo = input("Modelo......: ")
  marca  = input("Marca.......: ")
  ano    = int(input("Ano.........: "))
  preco  = float(input("Preço R$....: "))
  km     = int(input("Kilometragem: "))
  cor    = input("Cor.........: ")
  data   = input("Data Compra.: ")

  response = requests.post(url, json={
    "modelo": modelo,
    "marca": marca,
    "ano": ano,
    "preco": preco,
    "km": km,
    "cor": cor,
    "dataCompra": data
  })

  if response.status_code == 201:
    carro = response.json()
    print(f"Ok! Carro cadastrado com código: {carro['id']}")
  else:
    print("Erro... Não foi possível incluir o carro")  

def listagem():
  titulo("Listagem dos Veículos Cadastrados")

  response = requests.get(url)

  if response.status_code != 200:
    print("Erro... Não foi possível acessar a API")
    return
  
  carros = response.json()

  print("Cód. Modelo.............: Marca.........: Ano: Preço R$:")
  print("--------------------------------------------------------")

  for carro in carros:
    print(f"{carro['id']:4d} {carro['modelo']:20s} {carro['marca']:15s} {carro['ano']:4d} {float(carro['preco']):9.2f}")


def alteracao():
  listagem()

  id = int(input("\nQual o código do veículo a alterar? "))

  response = requests.get(url)
  carros = response.json()

  carro = [x for x in carros if x['id'] == id]

  if len(carro) == 0:
    print("Erro... Informe um código existente")
    return
  
  print(f"\nModelo..: {carro[0]['modelo']}")
  print(f"Marca...: {carro[0]['marca']}")
  print(f"Ano.....: {carro[0]['ano']}")
  print(f"Preço R$: {float(carro[0]['preco']):9.2f}")

  novoPreco = float(input("Novo Preço R$: "))

  response = requests.patch(url+"/"+str(id), json={
    "preco": novoPreco
  })

  if response.status_code == 200:
    carro = response.json()
    print("Ok! Carro alterado com sucesso!")
  else:
    print("Erro... Não foi possível alterar o preço do carro")  


def exclusao():
  listagem()

  id = int(input("\nQual código do veículo você deseja excluir (0: sair)? "))

  if id == 0:
    return

  response = requests.get(url)
  carros = response.json()

  carro = [x for x in carros if x['id'] == id]

  if len(carro) == 0:
    print("Erro... Informe um código existente")
    return
  
  print(f"\nModelo..: {carro[0]['modelo']}")
  print(f"Marca...: {carro[0]['marca']}")
  print(f"Ano.....: {carro[0]['ano']}")
  print(f"Preço R$: {float(carro[0]['preco']):9.2f}")

  confirma = input("Confirma a exclusão (S/N)? ").upper()

  if confirma == "S":  
    response = requests.delete(url+"/"+str(id))

    if response.status_code == 200:
      carro = response.json()
      print("Ok! Carro excluído com sucesso!")
    else:
      print("Erro... Não foi possível excluir este carro")  
  

def grafico():
  response = requests.get(url)

  if response.status_code != 200:
    print("Erro... Não foi possível acessar a API")
    return
  
  carros = response.json()
  labels = list(set([x['marca'] for x in carros]))
  sizes = [0] * len(labels)

  for carro in carros:
    index = labels.index(carro['marca'])
    sizes[index] += 1

  fig, ax = plt.subplots()
  ax.pie(sizes, labels=labels)
  plt.show()

def titulo(texto, traco="-"):
  print()
  print(texto)
  print(traco*40)

# ---------------------------- Programa Principal
while True:
  titulo("Cadastro de Veículos")
  print("1. Inclusão de Carros")
  print("2. Listagem de Carros")
  print("3. Alteração de Preço")
  print("4. Exclusão de Carro")
  print("5. Gráfico Comparando Marcas")
  print("6. Finalizar")
  opcao = int(input("Opção: "))
  if opcao == 1:
    inclusao()
  elif opcao == 2:
    listagem()
  elif opcao == 3:
    alteracao()
  elif opcao == 4:
    exclusao()
  elif opcao == 5:
    grafico()
  else:
    break