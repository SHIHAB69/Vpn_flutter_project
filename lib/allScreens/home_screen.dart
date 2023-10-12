

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/allControllers/Controller_home.dart';
import 'package:vpn_basic_project/allModels/vpn_status.dart';
import 'package:vpn_basic_project/allScreens/available_vpn_servers_location_screen.dart';
import 'package:vpn_basic_project/allWidgets/custom_widget.dart';
import 'package:vpn_basic_project/appPreferences/appPreferences.dart';
import 'package:vpn_basic_project/main.dart';
import 'package:vpn_basic_project/vpnEngine/vpn_engine.dart';

class HomeScreen extends StatelessWidget
{
  HomeScreen({super.key});

  final homeController = Get.put(ControllerHome());

  locationSelectionBottomNavigation(BuildContext context)
  {
return SafeArea(
  child: Semantics(
    button: true,
    child: InkWell(
      onTap: ()
      {
       Get.to(()=> AvailableVpnServersLocationScreen());
      },
      child: Container(
        color: Colors.redAccent, //Bottom(Select country/Location)
        padding: EdgeInsets.symmetric(horizontal: sizeScreen.width * .041),
        height: 62 ,
        child: Row(
          children: [
            
            Icon(
              CupertinoIcons.flag_circle,
              color: Colors.white,
              size: 36,
            ),

            const SizedBox(
              width: 12,
            ),

            Text(
              "Select Country / Location",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),

            Spacer(),

            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.keyboard_arrow_right,
                color: Colors.redAccent,
                size: 26,

              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
  }
  Widget vpnRoundButton()
  {
  return Column(
    children: [
      Semantics(
        button: true,
        child: InkWell(
          onTap: (){

          },
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: homeController.getRoundVpnButtonColor.withOpacity(.1),
            ),
            child: Container(
              padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: homeController.getRoundVpnButtonColor.withOpacity(.3),
                ),
              child: Container(
                height: sizeScreen.height * .14,
                width: sizeScreen.width * .14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: homeController.getRoundVpnButtonColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                 
                    Icon(
                      Icons.power_settings_new,
                      size: 30,
                      color: Colors.white,
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    Text(
                      homeController.getRoundVpnButtonText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
  }


  @override
  Widget build(BuildContext context)
  {
    VpnEngine.snapshotVpnStage().listen((event)
    {
      homeController.vpnConnectionState.value = event;
    });


    sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("MART VPN"),
        leading: IconButton(
          onPressed: (){

          },
          icon: Icon(Icons.perm_device_info),
        ),
        actions: [
          IconButton(
            onPressed: ()
            {
           Get.changeThemeMode(
             AppPreferences.isModeDark ? ThemeMode.light : ThemeMode.dark
           );
                 AppPreferences.isModeDark = !AppPreferences.isModeDark;

            },
            icon: Icon(Icons.brightness_2_outlined),
          ),
        ],
      ),
      bottomNavigationBar: locationSelectionBottomNavigation(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          //2 round widget
          //location + ping
        Obx(()=>  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomWidget(
              titleText: homeController.vpnInfo.value.countryLongNmae.isEmpty ?
              "Location"
                  : homeController.vpnInfo.value.countryLongNmae,
              subTitleText: "FREE",
              roundWidgetWithIcon: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.redAccent,
                child: homeController.vpnInfo.value.countryLongNmae.isEmpty ? Icon(
                  Icons.flag_circle,
                  size: 30,
                  color: Colors.white,
                ) : null,
                backgroundImage: homeController.vpnInfo.value.countryLongNmae.isEmpty
                    ? null
                    : AssetImage("countryFlags/${homeController.vpnInfo.value.countryShortName.toLowerCase()}.png"),
              ),
            ),

            CustomWidget(
              titleText: homeController.vpnInfo.value.countryLongNmae.isEmpty ?
              "60 ms"
                  : homeController.vpnInfo.value.ping + "ms",
              subTitleText: "PING",
              roundWidgetWithIcon: CircleAvatar(
                radius: 32,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.graphic_eq,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ],

        ),),

          //Buttons for vpn
          vpnRoundButton(),
          //2 round widget
          //Download + Upload
          StreamBuilder<VpnStatus?>(
            initialData: VpnStatus(),
            stream: VpnEngine.snapshotVpnStatus(),
            builder: (context, dataSnapshot)
            {
             return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidget(
                    titleText: "${dataSnapshot.data?.byteIn ?? '0 kbps'}",
                    subTitleText: "DOWNLOADING",
                    roundWidgetWithIcon: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.black54,
                      child: Icon(
                        Icons.arrow_circle_down,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  CustomWidget(
                    titleText: "${dataSnapshot.data?.byteOut ?? '0 kbps'}",
                    subTitleText: "UPLOADING",
                    roundWidgetWithIcon: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.purpleAccent,
                      child: Icon(
                        Icons.arrow_circle_up_rounded,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],

              );
            },

          ),
        ],
      ),
    );
  }
}
