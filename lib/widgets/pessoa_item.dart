import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:cp1mobile/models/pessoa.dart";

class PessoaItem extends StatelessWidget {
  final Pessoa pessoa;
  final VoidCallback onSaida;

  const PessoaItem({
    super.key,
    required this.pessoa,
    required this.onSaida,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pessoa.nome,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text("ID: ${pessoa.identificacao}"),
                Text(
                  "Entrada: ${DateFormat("dd/MM/yyyy 'às' HH:mm").format(pessoa.dataEntrada)}",
                ),
                //Só mostra a saída se a pessoa já saiu
                if (!pessoa.noAmbiente)
                  Text(
                    "Saída: ${DateFormat("dd/MM/yyyy 'às' HH:mm").format(pessoa.dataSaida!)}",
                  ),
                Text("Situação: ${pessoa.situacao}"),
              ],
            ),
          ),
          TextButton(
            onPressed: pessoa.noAmbiente ? onSaida : null,
            child: const Text("Saída"),
          ),
        ],
      ),
    );
  }
}
