import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a purple toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(
            title:
                'St. Paul\'s School, Rourkela (SPL & DSPL Election 2023-24)'),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isVisible = true;
  AudioPlayer thankYouPlay = AudioPlayer();
  AudioPlayer welcomePlay = AudioPlayer();
  AudioPlayer clickPlay = AudioPlayer();

  // Map<String, int> candidateList = {
  //   "ANUSHA": 0,
  //   "YUVRAJ": 0,
  //   "ANIKET": 0,
  //   "JESLIN": 0,
  //   "UPASHNA": 0,
  //   "PIYUSH": 0,
  //   "SHILPA": 0,
  //   "ANUSHKA": 0,
  //   "SANKET": 0,
  //   "SUDHINDRA": 0,
  // };

  Map<String, int> candidateCountList = {
    "ANUSHA": 0,
    "YUVRAJ": 0,
    "ANIKET": 0,
    "JESLIN": 0,
    "UPASHNA": 0,
    "PIYUSH": 0,
    "SHILPA": 0,
    "ANUSHKA": 0,
    "SANKET": 0,
    "SUDHINDRA": 0,
  };

  Map<String, bool> hover = {
    "ANUSHA": false,
    "YUVRAJ": false,
    "ANIKET": false,
    "JESLIN": false,
    "UPASHNA": false,
    "PIYUSH": false,
    "SHILPA": false,
    "ANUSHKA": false,
    "SANKET": false,
    "SUDHINDRA": false,
  };

  Map<String, bool> click = {
    "ANUSHA": false,
    "YUVRAJ": false,
    "ANIKET": false,
    "JESLIN": false,
    "UPASHNA": false,
    "PIYUSH": false,
    "SHILPA": false,
    "ANUSHKA": false,
    "SANKET": false,
    "SUDHINDRA": false,
  };

  List<String> boy = [
    "YUVRAJ",
    "ANIKET",
    "PIYUSH",
    "SANKET",
    "SUDHINDRA",
  ];

  List<String> girl = [
    "ANUSHA",
    "JESLIN",
    "UPASHNA",
    "SHILPA",
    "ANUSHKA",
  ];

  List<String> student = [];

  Map<String, String> candidateLogoList = {
    "ANUSHA": "2-01.jpg",
    "YUVRAJ": "3-01.jpg",
    "ANIKET": "4-01.jpg",
    "JESLIN": "5-01.jpg",
    "UPASHNA": "6-01.jpg",
    "PIYUSH": "7-01.jpg",
    "SHILPA": "8-01.jpg",
    "ANUSHKA": "1-01.jpg",
    "SANKET": "10-01.jpg",
    "SUDHINDRA": "9-01.jpg",
  };

  @override
  void initState() {
    boy.shuffle();
    girl.shuffle();
    student = [...girl, ...boy];

    initial();
    audio();

    super.initState();
  }

  Future<void> audio() async {
    try {
      await thankYouPlay.setPlayerMode(PlayerMode.lowLatency);
      await welcomePlay.setPlayerMode(PlayerMode.lowLatency);
      await clickPlay.setPlayerMode(PlayerMode.lowLatency);

      await thankYouPlay.setSourceAsset("audio/ty.mp3");
      await welcomePlay.setSourceAsset("audio/01.mp3");
      await clickPlay.setSourceAsset("audio/02.mp3");
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> initial() async {
    String st = await readCounter();
    if (st != "error !") {
      try {
        Map mp = json.decode(st);
        candidateCountList = mp.cast<String, int>();
      } catch (e) {
        candidateCountList = {
          "ANUSHA": 0,
          "YUVRAJ": 0,
          "ANIKET": 0,
          "JESLIN": 0,
          "UPASHNA": 0,
          "PIYUSH": 0,
          "SHILPA": 0,
          "ANUSHKA": 0,
          "SANKET": 0,
          "SUDHINDRA": 0,
        };
      }
    } else {
      writeCounter();
    }

    playWelcome();
  }

  void _hoverProcess(String stud, bool flag) {
    setState(() {
      hover.updateAll((name, value) => value = false);

      hover.update(
        stud,
        (value) => flag,
      );
    });
  }

  void _clickProcess(String stud) {
    bool isPresent = false;
    bool isGirl = girl.contains(stud);

    click.forEach((key, value) {
      bool isStudentGirl = girl.contains(key);
      if (isGirl == isStudentGirl && value == true) isPresent = true;
    });

    if (!isPresent) {
      setState(() {
        bool isGirl = girl.contains(stud);

        click.forEach((key, value) {
          bool isStudentGirl = girl.contains(key);

          if (stud != key && (isGirl == isStudentGirl)) {
            click.update(
              key,
              (value) => false,
            );
          }
        });

        click.update(
          stud,
          (value) => !value,
        );

        _incrementCounter();
      });
    }
  }

  void playThankYou() async {
    await thankYouPlay.resume();
  }

  void playWelcome() async {
    await welcomePlay.resume();
  }

  void playClick() async {
    await clickPlay.resume();
  }

  void _incrementCounter() {
    if (click.entries.where((e) => e.value == true).length == 1) {
      playClick();
    }

    if (click.entries.where((e) => e.value == true).length > 1) {
      setState(() {
        for (var e in click.entries) {
          if (e.value) {
            candidateCountList.update(
              e.key,
              (value) => value + 1,
            );
          }
        }

        writeCounter();

        isVisible = false;
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              playThankYou();

              Future.delayed(const Duration(seconds: 5), () {
                setState(() {
                  isVisible = true;
                });
                Navigator.of(context).pop(true);
              });
              return AlertDialog(
                title: Text(
                  'Thank You !',
                  style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onTertiaryContainer),
                  textAlign: TextAlign.center,
                ),
              );
            });

        boy.shuffle();
        girl.shuffle();
        student = [...girl, ...boy];

        click = {
          "ANUSHA": false,
          "YUVRAJ": false,
          "ANIKET": false,
          "JESLIN": false,
          "UPASHNA": false,
          "PIYUSH": false,
          "SHILPA": false,
          "ANUSHKA": false,
          "SANKET": false,
          "SUDHINDRA": false,
        };

        hover = {
          "ANUSHA": false,
          "YUVRAJ": false,
          "ANIKET": false,
          "JESLIN": false,
          "UPASHNA": false,
          "PIYUSH": false,
          "SHILPA": false,
          "ANUSHKA": false,
          "SANKET": false,
          "SUDHINDRA": false,
        };
      });
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> get _localBackupFile async {
    final path = await _localPath;
    return File('$path/counter_backup.txt');
  }

  Future<File> get _localResetFile async {
    final path = await _localPath;
    return File('$path/counter_reset.txt');
  }

  Future<String> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "error !";
    }
  }

  Future<void> writeCounter() async {
    var file = await _localFile;
    // Write the file
    file.writeAsString(jsonEncode(candidateCountList));

    file = await _localBackupFile;
    // Write the file
    file.writeAsString(jsonEncode(candidateCountList));
  }

  Future<void> resetCounter() async {
    final reset = await _localResetFile;
    // Write the file
    reset.writeAsString(jsonEncode(candidateCountList));

    final file = await _localFile;

    setState(() {
      candidateCountList = {
        "ANUSHA": 0,
        "YUVRAJ": 0,
        "ANIKET": 0,
        "JESLIN": 0,
        "UPASHNA": 0,
        "PIYUSH": 0,
        "SHILPA": 0,
        "ANUSHKA": 0,
        "SANKET": 0,
        "SUDHINDRA": 0,
      };
    });

    // Write the file
    file.writeAsString(jsonEncode(candidateCountList));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          const Image(
            image: AssetImage('assets/school.jpg'),
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Positioned(
            top: 1.h,
            child: Visibility(
              visible: isVisible,
              child: ElevatedButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Text(
                      "CHOOSE ",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "ONE GIRL CANDIDATE ",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent,
                      ),
                    ),
                    Icon(
                      Icons.woman,
                      size: 48,
                      color: Colors.pinkAccent,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 9.h,
            child: SizedBox(
              height: 400,
              width: 97.w,
              child: Visibility(
                visible: isVisible,
                child: GridView.count(
                  // shrinkWrap: true,
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: 5,
                  // Generate 100 widgets that display their index in the List.
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Opacity(
                        opacity: 0.95,
                        child: Card(
                          color: click.entries
                                  .firstWhere(
                                      (entry) => entry.key == girl[index])
                                  .value
                              ? girl.contains(girl[index])
                                  ? Colors.pinkAccent
                                  : Colors.blueAccent
                              : hover.entries
                                      .firstWhere(
                                          (entry) => entry.key == girl[index])
                                      .value
                                  ? girl.contains(girl[index])
                                      ? Colors.pinkAccent
                                      : Colors.blueAccent
                                  : Colors.blueGrey.shade100,
                          child: AnimatedContainer(
                            height: 70,
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.all(
                              (hover.entries
                                      .firstWhere(
                                          (entry) => entry.key == girl[index])
                                      .value)
                                  ? 15
                                  : 20,
                            ),
                            child: Stack(
                              children: [
                                Material(
                                  // needed
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onHover: (val) {
                                      _hoverProcess(girl[index], val);
                                    },
                                    onTap: () {
                                      _clickProcess(girl[index]);
                                      // _incrementCounter(student[index]);
                                    }, // needed
                                    child: Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/${candidateLogoList.entries.firstWhere((entry) => entry.key == girl[index]).value}'),
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   width: 200,
                                //   height: 200,
                                //   child: ClipRRect(
                                //     borderRadius: BorderRadius.circular(8.0),
                                //     child: Image(
                                //       fit: BoxFit.cover,
                                //       image: AssetImage(
                                //           'assets/${candidateLogoList.entries.firstWhere((entry) => entry.key == student[index]).value}'),
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 30,
                                // ),
                                ElevatedButton.icon(
                                  onHover: (val) {
                                    _hoverProcess(girl[index], val);
                                  },
                                  icon: (girl.contains(girl[index]))
                                      ? const Icon(
                                          Icons.woman,
                                          size: 32,
                                          color: Colors.pinkAccent,
                                        )
                                      : const Icon(
                                          Icons.man,
                                          size: 32,
                                          color: Colors.blueAccent,
                                        ),
                                  onPressed: () {
                                    _clickProcess(girl[index]);
                                    // _incrementCounter(student[index]);
                                  },
                                  label: Text(
                                    girl[index],
                                    style: TextStyle(
                                        color: (girl.contains(girl[index]))
                                            ? Colors.pinkAccent
                                            : Colors.blueAccent,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          Positioned(
            top: 47.h,
            child: Visibility(
              visible: isVisible,
              child: ElevatedButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Text(
                      "CHOOSE ",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "ONE BOY CANDIDATE ",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    Icon(
                      Icons.man,
                      size: 48,
                      color: Colors.blueAccent,
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 55.h,
            child: SizedBox(
              height: 400,
              width: 97.w,
              child: Visibility(
                visible: isVisible,
                child: GridView.count(
                  // shrinkWrap: true,
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: 5,
                  // Generate 100 widgets that display their index in the List.
                  children: List.generate(5, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Opacity(
                        opacity: 0.95,
                        child: Card(
                          color: click.entries
                                  .firstWhere(
                                      (entry) => entry.key == boy[index])
                                  .value
                              ? girl.contains(boy[index])
                                  ? Colors.pinkAccent
                                  : Colors.blueAccent
                              : hover.entries
                                      .firstWhere(
                                          (entry) => entry.key == boy[index])
                                      .value
                                  ? girl.contains(boy[index])
                                      ? Colors.pinkAccent
                                      : Colors.blueAccent
                                  : Colors.blueGrey.shade100,
                          child: AnimatedContainer(
                            height: 70,
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.all(
                              (hover.entries
                                      .firstWhere(
                                          (entry) => entry.key == boy[index])
                                      .value)
                                  ? 15
                                  : 20,
                            ),
                            child: Stack(
                              children: [
                                Material(
                                  // needed
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onHover: (val) {
                                      _hoverProcess(boy[index], val);
                                    },
                                    onTap: () {
                                      _clickProcess(boy[index]);
                                      // _incrementCounter(student[index]);
                                    }, // needed
                                    child: Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/${candidateLogoList.entries.firstWhere((entry) => entry.key == boy[index]).value}'),
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   width: 200,
                                //   height: 200,
                                //   child: ClipRRect(
                                //     borderRadius: BorderRadius.circular(8.0),
                                //     child: Image(
                                //       fit: BoxFit.cover,
                                //       image: AssetImage(
                                //           'assets/${candidateLogoList.entries.firstWhere((entry) => entry.key == student[index]).value}'),
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 30,
                                // ),
                                ElevatedButton.icon(
                                  onHover: (val) {
                                    _hoverProcess(boy[index], val);
                                  },
                                  icon: (girl.contains(boy[index]))
                                      ? const Icon(
                                          Icons.woman,
                                          size: 32,
                                          color: Colors.pinkAccent,
                                        )
                                      : const Icon(
                                          Icons.man,
                                          size: 32,
                                          color: Colors.blueAccent,
                                        ),
                                  onPressed: () {
                                    _clickProcess(boy[index]);
                                    // _incrementCounter(student[index]);
                                  },
                                  label: Text(
                                    boy[index],
                                    style: TextStyle(
                                        color: (girl.contains(boy[index]))
                                            ? Colors.pinkAccent
                                            : Colors.blueAccent,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String password = "";
          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  "Password",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: TextFormField(
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                ),
                actions: [
                  MaterialButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    child: const Text('OK'),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                        if (password == "5921") {
                          showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    "Election Summary",
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: FutureBuilder(
                                    builder: (ctx, snapshot) {
                                      // Checking if future is resolved or not
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        // If we got an error
                                        if (snapshot.hasError) {
                                          return Center(
                                            child: Text(
                                              '${snapshot.error} occurred',
                                              style: const TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          );

                                          // if we got our data
                                        } else if (snapshot.hasData) {
                                          // Extracting data from snapshot object
                                          final data = snapshot.data as String;

                                          Map mp = json.decode(data);
                                          Map<String, int> countList =
                                              mp.cast<String, int>();

                                          return SizedBox(
                                            width: 500,
                                            height: 70.h,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: countList.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                String key = countList.keys
                                                    .elementAt(index);
                                                return Column(
                                                  children: <Widget>[
                                                    ListTile(
                                                      dense: false,
                                                      isThreeLine: false,
                                                      title: Text(
                                                        key,
                                                        style: TextStyle(
                                                            fontSize: 32,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors
                                                                    .pinkAccent
                                                                : Colors
                                                                    .blueAccent),
                                                      ),
                                                      trailing: Text(
                                                        "${countList[key]}",
                                                        style: TextStyle(
                                                            fontSize: 32,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: index % 2 ==
                                                                    0
                                                                ? Colors
                                                                    .pinkAccent
                                                                : Colors
                                                                    .blueAccent),
                                                      ),
                                                    ),
                                                    const Divider(
                                                      height: 2.0,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        }
                                        //   return Center(
                                        //     child: Text(
                                        //       data
                                        //           .replaceAll(",", "\n")
                                        //           .replaceAll("}", "")
                                        //           .replaceAll("{", ""),
                                        //       style: const TextStyle(
                                        //           fontSize: 32,
                                        //           fontWeight: FontWeight.bold),
                                        //       textAlign: TextAlign.center,
                                        //     ),
                                        //   );
                                        // }
                                      }

                                      // Displaying LoadingSpinner to indicate waiting state
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },

                                    // Future that needs to be resolved
                                    // inorder to display something on the Canvas
                                    future: readCounter(),
                                  ),
                                  actions: [
                                    MaterialButton(
                                        color: Colors.red,
                                        textColor: Colors.white,
                                        child: const Text('RESET'),
                                        onPressed: () {
                                          showDialog(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Sure you want to reset ?',
                                                  style: TextStyle(
                                                    fontSize: 32,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: [
                                                  MaterialButton(
                                                      color: Colors.red,
                                                      textColor: Colors.white,
                                                      child:
                                                          const Text('RESET'),
                                                      onPressed: () {
                                                        resetCounter();
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      }),
                                                  MaterialButton(
                                                      color: Colors.green,
                                                      textColor: Colors.white,
                                                      child:
                                                          const Text('CANCEL'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      }),
                                                ],
                                              );
                                            },
                                          );
                                        }),
                                    MaterialButton(
                                        color: Colors.green,
                                        textColor: Colors.white,
                                        child: const Text('DONE'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  ],
                                );
                              });
                        }
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.info_outline_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
