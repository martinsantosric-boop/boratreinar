# Cooper Maratonista

Aplicativo Flutter para corredores registrarem treinos com GPS, tempo,
distancia, pace medio, velocidade, calorias estimadas, historico local e metas
semanais.

## Funcionalidades

- Iniciar, pausar, continuar e finalizar corrida.
- Medicao de distancia por GPS usando `geolocator`.
- Contador de passos durante a corrida usando o sensor nativo do aparelho.
- Calculo de pace medio, velocidade media e calorias estimadas por MET.
- Historico local com `shared_preferences`.
- Registro manual de treino quando a corrida foi feita fora do app.
- Meta semanal editavel e progresso mensal.
- Perfil do corredor com peso, altura e idade para personalizar estimativas.
- Permissoes Android/iOS configuradas para localizacao em uso.
- Permissoes preparadas para localizacao em segundo plano, bussola,
  sensores de movimento, passos, sensores corporais, notificacoes e Bluetooth
  esportivo.

## Como rodar

```bash
flutter pub get
flutter run
```

## Validacao

```bash
flutter analyze
flutter test
flutter build web --no-pub
```

> A build Android pode demorar na primeira execucao porque o Gradle baixa e
> prepara dependencias nativas.
