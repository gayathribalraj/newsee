/* view folder contains the widget code ( stateless widget ) */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/timer/bloc/timer_bloc.dart';

class TimerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Timer With BLoC")),
      body: Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(child: TimerText()),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100.0),
                child: Center(child: Actions()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ...switch (state) {
              TimerInitial() => [
                FloatingActionButton(
                  child: const Icon(Icons.play_arrow),
                  onPressed:
                      () => context.read<TimerBloc>().add(
                        TimerStarted(duration: state.duration),
                      ),
                ),
              ],
              TimerRunInprogress() => [
                FloatingActionButton(
                  child: const Icon(Icons.pause),
                  onPressed:
                      () => context.read<TimerBloc>().add(const TimerPaused()),
                ),
                FloatingActionButton(
                  child: const Icon(Icons.replay),
                  onPressed:
                      () => context.read<TimerBloc>().add(const TimerReset()),
                ),
              ],
              TimerRunPause() => [
                FloatingActionButton(
                  child: const Icon(Icons.play_arrow),
                  onPressed:
                      () => context.read<TimerBloc>().add(const TimerResumed()),
                ),
                FloatingActionButton(
                  child: const Icon(Icons.replay),
                  onPressed:
                      () => context.read<TimerBloc>().add(const TimerReset()),
                ),
              ],
              TimerRunComplete() => [
                FloatingActionButton(
                  child: Icon(Icons.replay),
                  onPressed:
                      () => context.read<TimerBloc>().add(const TimerReset()),
                ),
              ],
            },
          ],
        );
      },
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});
  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(
      2,
      '0',
    );
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.blue.shade500],
        ),
      ),
    );
  }
}
