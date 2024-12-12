import 'dart:ui';

import 'package:audio_waveforms/audio_waveforms.dart' as AW;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:memo/player/bloc/player_bloc.dart';
import 'package:memo/player/bloc/player_events.dart';
import 'package:memo/player/bloc/player_states.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  void initState() {
    context.read<PlayerBloc>().add(DownloadAudio());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlayerBloc, PlayerState>(
      listener: (context, state) {
        if (state is AudioError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        String formatDuration(Duration duration) {
          String twoDigits(int n) => n.toString().padLeft(2, "0");
          final minutes = twoDigits(duration.inMinutes.remainder(60));
          final seconds = twoDigits(duration.inSeconds.remainder(60));
          return "$minutes:$seconds";
        }

        return Scaffold(
          extendBody: true,
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/images/bg.png",
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(40)),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff313131).withOpacity(0.75),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, -5),
                            blurRadius: 15,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 36, left: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Instant Crush",
                                  style: GoogleFonts.roboto(
                                      fontSize: 34,
                                      letterSpacing: 34 * 3 / 100,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromRGBO(
                                          237, 237, 237, 1)),
                                ),
                                Text(
                                  "feat. Julian Casablancas",
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      letterSpacing: 16 * 3 / 100,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromRGBO(
                                          237, 237, 237, 1)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                if (state is AudioInitial ||
                                    state is AudioLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ));
                                } else if (state is AudioDownloaded ||
                                    state is AudioPlaying ||
                                    state is AudioPaused) {
                                  return Center(
                                    child: AW.AudioFileWaveforms(
                                      playerController: context
                                          .read<PlayerBloc>()
                                          .playerController,
                                      playerWaveStyle: const AW.PlayerWaveStyle(
                                          liveWaveColor: Color(0xffededed),
                                          spacing: 10,
                                          waveThickness: 5,
                                          seekLineColor: Colors.transparent,
                                          fixedWaveColor: Color(0xFF747578)),
                                      size: Size(
                                          MediaQuery.of(context).size.width,
                                          100),
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: Text('Something went wrong'));
                                }
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text(
                                  formatDuration(state.duration),
                                  style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      letterSpacing: 16 * 3 / 100,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromRGBO(
                                          237, 237, 237, 1)),
                                ),
                                InkWell(
                                  onTap: () {
                                    if (state is AudioPlaying) {
                                      context
                                          .read<PlayerBloc>()
                                          .add(PauseAudio());
                                    } else {
                                      context
                                          .read<PlayerBloc>()
                                          .add(PlayAudio());
                                    }
                                  },
                                  child: Visibility(
                                    visible: state is AudioPlaying,
                                    replacement:
                                        Image.asset("assets/icons/play.png"),
                                    child:
                                        Image.asset("assets/icons/pause.png"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
