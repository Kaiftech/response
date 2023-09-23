import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EmergencyServicesPage extends StatelessWidget {
  final List<EmergencyService> emergencyServices = [
    const EmergencyService(
      serviceType: 'Cyclone',
      serviceContactNumber: 'https://www.ndma.gov.in/Natural-Hazards/Cyclone',
    ),
    const EmergencyService(
      serviceType: 'Tsunami',
      serviceContactNumber: 'https://www.ndma.gov.in/Natural-Hazards/Tsunami',
    ),
    const EmergencyService(
      serviceType: 'Heat Wave',
      serviceContactNumber: 'https://www.ndma.gov.in/Natural-Hazards/Heat-Wave',
    ),
    const EmergencyService(
      serviceType: 'Landslide',
      serviceContactNumber: 'https://www.ndma.gov.in/Natural-Hazards/Landslide',
    ),
    const EmergencyService(
      serviceType: 'Floods',
      serviceContactNumber: 'https://www.ndma.gov.in/Natural-Hazards/Floods',
    ),
    const EmergencyService(
      serviceType: 'Earthquakes',
      serviceContactNumber:
          'https://www.ndma.gov.in/Natural-Hazards/Earthquakes',
    ),
    // Add other emergency services here
  ];

  EmergencyServicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Services Guidelines'),
      ),
      body: ListView.builder(
        itemCount: emergencyServices.length,
        itemBuilder: (context, index) {
          final service = emergencyServices[index];
          return EmergencyServiceCard(service: service);
        },
      ),
    );
  }
}

class EmergencyServiceCard extends StatelessWidget {
  final EmergencyService service;

  const EmergencyServiceCard({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => EmergencyServiceWebView(
                initialUrl: service.serviceContactNumber,
                pageTitle: service.serviceType,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.warning,
                size: 48.0,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.serviceType,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'View Guidelines',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmergencyServiceWebView extends StatelessWidget {
  final String initialUrl;
  final String pageTitle;

  const EmergencyServiceWebView({
    Key? key,
    required this.initialUrl,
    required this.pageTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
      ),
      body: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          if (request.url == initialUrl) {
            return NavigationDecision.navigate;
          } else {
            return NavigationDecision.prevent;
          }
        },
      ),
    );
  }
}

class EmergencyService {
  final String serviceType;
  final String serviceContactNumber;

  const EmergencyService({
    required this.serviceType,
    required this.serviceContactNumber,
  });
}
