part of './pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool ready = false;
  bool _remember = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    final authProvider = await Future.delayed(Duration.zero).then((value) => Provider.of<AuthProvider>(context, listen: false));

    final LoginModel credentials = Storages.getCredentials;
    authProvider.credentials = credentials;
    _remember = credentials.remember;
    if (_remember) {
      _emailController.text = authProvider.credentials.username ?? '';
    }
    authProvider.autenticated(login: true);
    ready = true;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(NavigatonServices.navigatiorKey.currentContext!);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: (!ready)
          ? Container()
          : Stack(
              children: [
                Positioned.fill(
                  bottom: -50,
                  right: -120,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: BackCircle(
                      size: 200,
                      color: TColors.priRed,
                    ),
                  ),
                ),
                Positioned.fill(
                  right: -50,
                  bottom: -120,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: BackCircle(
                      size: 180,
                      color: TColors.seconRed,
                    ),
                  ),
                ),
                FadeIn(
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 200,
                              child: Hero(
                                tag: 'imageLogo',
                                child: Image(
                                  image: AssetImage('assets/img/yuneta_logo.png'),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter email';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Enter email',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                authProvider.credentials.username = value;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _passwordController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter password';
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Enter password',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                authProvider.credentials.password = value;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            Checkbox(
                              activeColor: const Color(0xffd30439),
                              value: _remember,
                              onChanged: (value) {
                                authProvider.credentials.remember = value!;
                                _remember = value;
                                setState(() {});
                              },
                            ),
                            const SizedBox(height: 16.0),
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: TColors.seconRed, // Background color
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    authProvider.onLogin(context: context);
                                  }
                                },
                                child: const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
