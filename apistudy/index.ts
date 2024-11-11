import express from 'express'
import clienteRoute from './routes/cliente'
import vendedorRoute from './routes/vendedor'
import AtendimentoRoute from './routes/atendimento'

const app = express()
const porta = 3000
app.use("/Clientes", clienteRoute)
app.use("/Vendedores", vendedorRoute)
app.use("/Atendimento", AtendimentoRoute)

app.get('/', (req, res) => {
    res.send('API: Teste vendedora de carros xdddddd')
})

app.listen(port, () => {
    console.log(`Server rodando na porta: ${porta}`)
})


