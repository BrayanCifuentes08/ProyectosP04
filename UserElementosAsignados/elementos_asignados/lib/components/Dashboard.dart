import 'package:elementos_asignados/common/ThemeNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Dashboard extends StatefulWidget {
  final bool isBackgroundSet;
  final String imagePath;
  final Function(Locale) changeLanguage;
  final Function onScrollToDown;
  final Function onScrollToTop;
  Locale idiomaDropDown;
  // final bool temaClaro;
  // final String token;
  // final String pUserName;
  // final int pEmpresa;
  // final int pEstacion_Trabajo;
  // String baseUrl;
  // final DateTime fechaSesion;
  // final DateTime? fechaExpiracion;
  // final String? despEmpresa;
  // final String? despEstacion_Trabajo;

  Dashboard({
    required this.isBackgroundSet,
    required this.imagePath,
    required this.changeLanguage,
    required this.idiomaDropDown,
    required this.onScrollToDown,
    required this.onScrollToTop,
    // required this.token,
    // required this.pUserName,
    // required this.pEmpresa,
    // required this.pEstacion_Trabajo,
    // required this.fechaSesion,
    // required this.despEmpresa,
    // required this.despEstacion_Trabajo,
    // this.fechaExpiracion,
  });
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isAsignarElemento = true;
  bool isDesasignarElemento = true;
  bool mostrarGridElementosUsuario = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(
            color: widget.isBackgroundSet
                ? Color.fromARGB(0, 21, 70, 144)
                : (!themeNotifier.temaClaro
                    ? Color(0xFFF111827)
                    : Colors.white),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: Offset(0, 5),
              ),
            ],
            image: widget.isBackgroundSet
                ? DecorationImage(
                    image: AssetImage(widget.imagePath),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 1,
                  runSpacing: 1,
                  alignment: WrapAlignment.start,
                  children: [
                    // Tarjeta de Usuario
                    _buildUserCard('John Doe', '10:00 AM', '12:00 PM'),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isAsignarElemento = false;
                              isDesasignarElemento = true;
                              mostrarGridElementosUsuario = isAsignarElemento;
                            });
                          },
                          child: Text(
                            'Asignar elementos',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isAsignarElemento
                                ? Color(0xFFF194a5a)
                                : Colors.blue,
                          ),
                        ),
                        SizedBox(height: 10), // Espacio entre los botones
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isDesasignarElemento = false;
                              isAsignarElemento = true;
                              mostrarGridElementosUsuario =
                                  isDesasignarElemento;
                            });
                          },
                          child: Text(
                            'Desasignar elementos',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDesasignarElemento
                                ? Color(0xFFF194a5a)
                                : Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(
                  height: 80,
                  thickness: 2,
                  color: Colors.grey,
                ),
                if (mostrarGridElementosUsuario)
                  Flexible(
                    fit: FlexFit.loose,
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      children: <Widget>[
                        _buildAssignedItemCard('Elemento 1', Icons.assignment),
                        _buildAssignedItemCard(
                            'Elemento 2', Icons.assignment_turned_in),
                        _buildAssignedItemCard('Elemento 3', Icons.assessment),
                        _buildAssignedItemCard('Elemento 4', Icons.book),
                        _buildAssignedItemCard('Elemento 5', Icons.assessment),
                        _buildAssignedItemCard('Elemento 6', Icons.book),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Tarjeta para mostrar la información del usuario
  Widget _buildUserCard(String name, String sessionStart, String sessionEnd) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 40, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('Sesión: $sessionStart'),
            Text('Expira: $sessionEnd'),
          ],
        ),
      ),
    );
  }

  // Tarjeta para los elementos asignados al usuario
  Widget _buildAssignedItemCard(String itemName, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.green),
            SizedBox(height: 10),
            Text(
              itemName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
