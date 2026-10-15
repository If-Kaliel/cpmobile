import "package:flutter/material.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:intl/intl.dart";
import "package:cp1mobile/models/pessoa.dart";
import "package:cp1mobile/utils/cores.dart";

class PessoaItem extends StatelessWidget {
  final Pessoa pessoa;
  final VoidCallback onSaida;
  final VoidCallback onExcluir;

  const PessoaItem({
    super.key,
    required this.pessoa,
    required this.onSaida,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          extentRatio: 0.5,
          children: [
            SlidableAction(
              onPressed: (context) {
                onSaida();
              },
              backgroundColor: Cores.roxoNeon,
              foregroundColor: Colors.white,
              icon: Icons.logout,
              label: "Saída",
            ),
            SlidableAction(
              onPressed: (context) {
                onExcluir();
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: "Excluir",
            ),
          ],
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Cores.roxoTransparente,
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
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "ID: ${pessoa.identificacao}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Entrada: ${DateFormat("dd/MM/yyyy 'às' HH:mm").format(pessoa.dataEntrada)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    //Só mostra a saída se a pessoa já saiu
                    if (!pessoa.noAmbiente)
                      Text(
                        "Saída: ${DateFormat("dd/MM/yyyy 'às' HH:mm").format(pessoa.dataSaida!)}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    Text(
                      "Situação: ${pessoa.situacao}",
                      style: TextStyle(
                        color: pessoa.noAmbiente ? Cores.verdeNeon : Cores.vermelho,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: pessoa.noAmbiente ? onSaida : null,
                style: TextButton.styleFrom(foregroundColor: Cores.rosaNeon),
                child: const Text("Saída"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
