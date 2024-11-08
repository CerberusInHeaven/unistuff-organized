import express from 'express'
import routesCarros from './routes/carros'
import userroute from './routes/users'

const app = express()
const port = 3000

app.use(express.json())

app.use("/carros", routesCarros)
app.use("/Usuarios", userroute)

app.get('/', (req, res) => {
  res.send('API de Cadastro de Carros')
})

app.listen(port, () => {
  console.log(`Servidor rodando na porta: ${port}`)
})