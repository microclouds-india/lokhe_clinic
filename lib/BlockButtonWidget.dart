import 'package:flutter/material.dart';

class BlockButtonWidget extends StatelessWidget {
  const BlockButtonWidget({required this.color,required this.text,required this.onPressed});

  final Color color;
  final Widget text;
  // final Image icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: this.color.withOpacity(0.3),blurRadius: 40,offset: Offset(0,3)),
          BoxShadow(color: this.color.withOpacity(0.2),blurRadius: 13,offset: Offset(0,3)),
        ],
      ),
      child: MaterialButton(
        onPressed: this.onPressed,
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 14),
        color: this.color,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment:CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // this.icon==null
            //     ?SizedBox()
            //     :Container(margin: EdgeInsets.only(right: 14),height: 25,width: 25, child:this.icon,),
            this.text,
          ],
        ),
      ),
    );
  }
}
