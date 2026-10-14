import 'package:flutter/material.dart';
import 'package:cp1mobile/utils/cores.dart';

//Card que mostra quantas pessoas estão no camarote e se ainda pode entrar
class ContadorLotacao extends StatelessWidget {
  const ContadorLotacao({
    super.key,
    required this.pessoasNoAmbiente,
    required this.capacidade,
    required this.isFull,
  });

  final int pessoasNoAmbiente;
  final int capacidade;
  final bool isFull;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Cores.roxoTransparente,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people, color: Colors.white),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  "Pessoas no ambiente: $pessoasNoAmbiente / $capacidade",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Center(
            child: Text(
              isFull ? "Camarote lotado! Não é possível registrar uma nova entrada." : "Pode entrar",
              textAlign: TextAlign.center,
              style: TextStyle(color: isFull ? Cores.vermelho : Cores.verdeNeon),
            ),
          ),
        ],
      ),
    );
  }
}
