import { Item } from "./item.model"

export class Pedido {
    public loja: string
    public natureza: string
    public status: string
    public tipoPed: string
    public cliente : string
    public numero : string
    public condPagto : string
    public itens: Item[]
    public nomeCliente : string
    public operacao: number
}