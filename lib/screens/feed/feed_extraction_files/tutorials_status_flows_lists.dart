import 'dart:math';

import 'package:clapmi/global_object_folder_jacket/global_widgets/global_widgets.dart';
import 'package:clapmi/screens/feed/feed_extraction_files/showcase_widget.dart';
import 'package:flutter/material.dart';

final howComboWorks = [
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 0,
      messageBoxAlignment: Alignment(0, .2),
      pointerAlignment: Alignment(.5, -.2),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/HTCGW-image-1.png"),
      ),
      tags: [],
      // for fan pov and creator pov
      description: 'Earn as a creator or a fan ',
      instructions:
          "Explore clapmi's combo ground either as creator or a regular fan and get to enjoy the unique benfit of the combo ground ",
      pointerWidget: SizedBox()),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 22.5,
      messageBoxAlignment: Alignment(0, -.4),
      pointerAlignment: Alignment(-.6, .8),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/HTCGW-image-2.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "select on of the ongoing Stream from the Combo Ground  using the join now or use the info buttom to know more about the stream  "),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 135,
      messageBoxAlignment: Alignment(0, .2),
      pointerAlignment: Alignment(-1, -.4),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/HTCGW-image-4.png"),
      ),
      tags: [],
      description: 'Join now buttom', // for fan pov and creator pov
      instructions:
          "use the join buttom to easily hop into a stream, and join other pericipant  "),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/HTCGW-image-3.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Send claps and gift or challenge your favourites Stremers on clapmi and erarn while doing that, its simple and intuitive"),
];

final singleLiveStream = [
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 0,
      messageBoxAlignment: Alignment(0, .2),
      pointerAlignment: Alignment(.5, -.2),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/golive1.png"),
      ),
      tags: [],
      // for fan pov and creator pov
      description: 'Earn as a creator or a fan ',
      instructions:
          "to create a single livestream, head over to combo ground or use the post button to get things started  ",
      pointerWidget: SizedBox()),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 22.5,
      messageBoxAlignment: Alignment(0, -.4),
      pointerAlignment: Alignment(-.6, .8),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/go2.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Navigate to golive and tap on create livestream to start your personal stream "),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 135,
      messageBoxAlignment: Alignment(0, .2),
      pointerAlignment: Alignment(-1, -.4),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/go3.png"),
      ),
      tags: [],
      description: 'Join now buttom', // for fan pov and creator pov
      instructions:
          "fill the quick form, its quick and simple and once you done just tap create livestream"),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/go4.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "All you have to wait for clapmi to egin your livestream and that all "),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/go5.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Finally, your stream has started, earn and bring up your fans for challenge and have fun "),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/go6.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "As a fan you can view all the challenges on the stream by tapping two glove button "),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/go7.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Here all challenges can be viewed before having your challenge added. "),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/go8.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "To initiate the challenge use the challenge button to get it initiated. "),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/go9.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Fill up the quick form and boost your challenge (optional) to get a better chance of getting brought up for the stream faster. "),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/go10.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Send your request for the challenge and let clapmi do its thing in seconds and get ready for the challenge."),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/go11.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions: "Request sent "),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/go12.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "All you have to do is to just wait till the host bring you up for the challenge and that’s all"),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/go13.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Here is a step by step guide on how to boost your challenge and gain an advantage over other challengers."),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/go15.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "On the challenge list find your tag and in front of it you should seethe boost button, tap on the plus icon to add a boost."),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/go16.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Enter your desired clap points to boost your challenge to the top. Make sure your clap point is higher than that of the top challenger"),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/go17.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Tap here to see the challenge list and see where you are place on it.."),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/go18.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "With that, you ate now at the top of the challenge list which should increase the chance of your challenge to be accepted.."),
];

final challengeRequest = [
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/re1.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions: "Use this icon to access the challenge feature of clapmi"),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/re2.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Select the challenge brag option to start the challenge process."),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/re3.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions: ""),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/re4.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Use the join now button to easily hop into a stream, and join other participants."),
];

final moneyDeposit = [
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/depo1.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions: "."),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/depo2.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions: ""),
];

final withdrawMoney = [
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/wallet1.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "This is a step by step guide on how to withdraw funds from your clapmi wallet."),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/wallet2.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Use any of the following option to proceed ro withdrawal and have your earnings in your account promptly."),
];

final howtoGift = [
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/show2.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions: ""),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/giftshow2.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions: ""),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/giftshow3.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions: ""),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/show3.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions: ""),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/show4.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions: ""),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/show5.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions: ""),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/images/show6.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions: ""),
];

final howtoBuypoint = [
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/dey.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Start by using the buy point button to access the buy point feature."),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/buy4.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Enter/select your desired amount, choose bank transfer and proceed to use the buy point button."),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/buy5.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Transfer to the account and follow the instructions and hit the “I HAVE TRANSFERRED” button to begin the payment process"),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/buy7.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Click on done to go back to your wallet and view your new wallet balance with your account already credited with the new clap point."),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/buy8.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Start by using the buy point button to access the buy point feature."),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/buy9.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Enter/select your desired amount, choose USDT and proceed to use the buy point button."),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/buy10.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Review the summary of the transaction and hit the buy point button. Its that simple!"),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/buy11.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Click on done to go back to your wallet and view your new wallet balance with your account already credited with the new clap point. "),
];

final wallet = [
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/wa1.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "The wallet is a vital part of clapmi system as it host the finances of each user. This section highlights the  total wallet balance of every clapmi user"),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/wa2.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Swap clap points into USDT or USDC within seconds at no extra fee and vice versa. "),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/wa3.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "The wallet has a couple assets(currency) that are generally common in crypto plus the clap point which is the in app currency that can be used transactions on clapmi. "),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/wa4.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "See every type of transaction that have been made on your account with the transaction history. "),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/wa5.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions: "View all your gift to other members of clapmi"),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/wa6.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Keep track of all the votes you made for your favorite streamer on clapmi’s combo ground."),
];

final reward = [
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/reward.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Clapmi users can claim one free clap point daily by visiting the reward page and tapping the claim point button"),
  ShowcaseStepModel(
      pointerAngle: (pi / 180) * 270,
      messageBoxAlignment: Alignment(0, 0),
      pointerAlignment: Alignment(-1, -1),
      backgroundWidget: FancyContainer(
        backgroundColor: Colors.black,
        child: Image.asset("assets/icons/reward2.png"),
      ),
      tags: [], // for fan pov and creator pov
      instructions:
          "Clap point rewards can also be earned by completing task on the reward page, each task come with its own unique rewards."),
];
