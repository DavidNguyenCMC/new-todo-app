import 'package:grpc/grpc.dart';

class GrpcConfig {
  final ClientChannel _clientChannel;
  GrpcConfig()
      : _clientChannel = ClientChannel(
          '192.168.1.25',
          port: 8000,
          options: const ChannelOptions(
            credentials: ChannelCredentials.insecure(),
          ),
        );

  ClientChannel get clientChannel => _clientChannel;
}
