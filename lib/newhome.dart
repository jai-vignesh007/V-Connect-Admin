import 'package:flutter/material.dart';
class Newhome extends StatelessWidget {
  const Newhome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe5e5e5),
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(" student\n login",style: TextStyle(fontSize: 22,),),
                    decoration: BoxDecoration(

                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(alignment: Alignment.bottomRight,

                            image: NetworkImage("https://skill.samsodisha.gov.in/studentmanagement/img/diplomacart.png")

                        )
                    ),
                    height: 100,

                  ),
                ),

              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(" Events",style: TextStyle(fontSize: 22,),),
                    decoration: BoxDecoration(

                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(alignment: Alignment.bottomRight,

                        image: NetworkImage("https://www.ringcentral.com/us/en/blog/wp-content/uploads/2022/02/In-person-team-building.jpg",)

                      )
                    ),
                    height: 100,

                  ),
                ),

              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // color: Colors.white,
                    decoration: BoxDecoration(

          color: Colors.white,
          borderRadius: BorderRadius.circular(10),),
                    child: Stack(

                      children:[
                      //   Container(
                      //   child: Text("Attendance",style: TextStyle(fontSize: 22,),),
                      //   width: ,
                      //   decoration: BoxDecoration(
                      //
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(10),
                      //       // image: DecorationImage(alignment: Alignment.bottomRight,
                      //       //
                      //       //     image: NetworkImage("https://assets-global.website-files.com/5ef5480befd3922fbeacf53c/5f51e401c1ad366c50bc64c1_hero-image-Events.png"),
                      //       //
                      //       //
                      //       // ),
                      //
                      //   ),
                      //   height: 100,
                      //
                      // ),
                        Text("Attendance",style: TextStyle(fontSize: 22,),),
                        Positioned(


                            child:Image.network("https://assets-global.website-files.com/5ef5480befd3922fbeacf53c/5f51e401c1ad366c50bc64c1_hero-image-Events.png",height: 100,))
    ]
                    ),
                  ),
                ),

              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Text(" Events",style: TextStyle(fontSize: 22,),),
                    decoration: BoxDecoration(

                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(alignment: Alignment.bottomRight,

                            image: AssetImage("assets/blooddonor.jpg")

                        )
                    ),
                    height: 100,

                  ),
                ),
              )

            ],
          ),

        ],
      ),
    );
  }
}
