
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sakcamera_getx/constant/main_constant.dart';
import 'package:sakcamera_getx/util/main_util.dart';

class MainComponet {
  // ===> ฟอร์มปกติ <=== //
  static Container mainFormField(
    BuildContext context,
    BoxConstraints constraints, {
    String? title,
    TextEditingController? controller,
    String textvaridation = '',
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputformatters,
    TextInputType? keyboardtype,
    double? width,
    double? height,
    double? heightvalidation,
    bool statusvalidation = false,
    bool statusobscuretext = false,
    Widget? prefix,
    Widget? prefixicon,
    BoxConstraints? prefixiconconstraints,
    Widget? suffixicon,
    Color? colorerror,
    Color? colorcurcer,
    Color? colortitle,
    Color? colorborder,
    Color? colortext,
    void Function(String)? onchanged,
  }) => Container(
    width: width,
    height: statusvalidation ? heightvalidation : height,
    decoration: BoxDecoration(),
    child: TextFormField(
      controller: controller,
      obscureText: statusobscuretext,
      keyboardType: keyboardtype,
      inputFormatters: inputformatters,
      cursorColor: colorcurcer ?? MainConstant.yellow3,
      style: MainUtil.mainTextStyle(
        context,
        constraints,
        fontcolor: colortext,
        fontsize: MainConstant.h16,
        fontweight: MainConstant.boldfontweight,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        // labelText: title,
        labelStyle: MainUtil.mainTextStyle(
          context,
          constraints,
          fontcolor: colortitle,
          fontsize: MainConstant.h16,
          fontweight: MainConstant.boldfontweight,
        ),
        label: MainUtil.mainText(
          context,
          constraints,
          text: title,
          textstyle: MainUtil.mainTextStyle(
            context,
            constraints,
            fontcolor: colortitle,
            fontsize: MainConstant.h16,
            fontweight: MainConstant.boldfontweight,
          ),
          overflow: TextOverflow.visible,
          softwrap: true,
        ),
        prefixIcon: prefix != null ? null : prefixicon,
        prefixIconConstraints: prefix != null ? null : prefixiconconstraints,
        prefix: prefix,
        suffixIcon: suffixicon,
        contentPadding: EdgeInsets.symmetric(
          vertical: MainConstant.setHeight(context, constraints, 0),
          horizontal: MainConstant.setWidth(context, constraints, 25),
        ),
        filled: true,
        fillColor: MainConstant.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MainConstant.setWidth(context, constraints, 36)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MainConstant.setWidth(context, constraints, 36)),
          borderSide: BorderSide(
            color: colorborder ?? MainConstant.white,
            // width: MainConstant.setWidth(context, constraints, 1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MainConstant.setWidth(context, constraints, 36)),
          borderSide: BorderSide(
            color: colorborder ?? MainConstant.white,
            width: MainConstant.setWidth(context, constraints, 1),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MainConstant.setWidth(context, constraints, 36)),
          borderSide: BorderSide(color: colorerror ?? MainConstant.yellow3),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MainConstant.setWidth(context, constraints, 36)),
          borderSide: BorderSide(color: colorerror ?? MainConstant.yellow3),
        ),
        errorStyle: MainUtil.mainTextStyle(
          context,
          constraints,
          fontcolor: colorerror ?? MainConstant.yellow3,
          fontsize: MainConstant.h14,
        ),
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.trim().isEmpty) {
              return textvaridation;
            }
            return null;
          },
      onChanged: onchanged,
    ),
  );

  // ===> ฟอร์มวันเกิด <=== //
  static Container mainDateField(
    BuildContext context,
    BoxConstraints constraints, {
    String? title,
    TextEditingController? controller,
    void Function()? ontap,
    String textvaridation = '',
    double? width,
    double? height,
    double? heightvalidation,
    bool statusvalidation = false,
    bool statusobscuretext = false,
    Widget? prefix,
    Widget? prefixicon,
    BoxConstraints? prefixiconconstraints,
    Widget? suffixicon,
    Color? colorcurcer,
    Color? colortitle,
    Color? colorborder,
    Color? colortext,
    Color? colorerror,
    void Function(String)? onchanged,
  }) => Container(
    width: width,
    height: statusvalidation ? heightvalidation : height,
    decoration: BoxDecoration(),
    child: TextFormField(
      controller: controller,
      readOnly: true,
      onTap: ontap,
      cursorColor: colorcurcer ?? MainConstant.white,
      style: MainUtil.mainTextStyle(
        context,
        constraints,
        fontcolor: colortext ?? MainConstant.white,
        fontsize: MainConstant.h16,
        fontweight: MainConstant.boldfontweight,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        label: MainUtil.mainText(
          context,
          constraints,
          text: title ?? '',
          textstyle: MainUtil.mainTextStyle(
            context,
            constraints,
            fontcolor: colortitle ?? MainConstant.white,
            fontsize: MainConstant.h16,
            fontweight: MainConstant.boldfontweight,
          ),
          overflow: TextOverflow.visible,
          softwrap: true,
        ),
        prefixIcon: prefixicon,
        prefixIconConstraints: prefixiconconstraints,
        suffixIcon: suffixicon,
        contentPadding: EdgeInsets.symmetric(
          vertical: MainConstant.setHeight(context, constraints, 0),
          horizontal: MainConstant.setWidth(context, constraints, 25),
        ),
        filled: true,
        fillColor: MainConstant.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MainConstant.setWidth(context, constraints, 36)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MainConstant.setWidth(context, constraints, 36)),
          borderSide: BorderSide(color: colorborder ?? MainConstant.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MainConstant.setWidth(context, constraints, 36)),
          borderSide: BorderSide(
            color: colorborder ?? MainConstant.white,
            width: MainConstant.setWidth(context, constraints, 1),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MainConstant.setWidth(context, constraints, 36)),
          borderSide: BorderSide(color: colorerror ?? MainConstant.yellow3),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(MainConstant.setWidth(context, constraints, 36)),
          borderSide: BorderSide(color: colorerror ?? MainConstant.yellow3),
        ),
        errorStyle: MainUtil.mainTextStyle(
          context,
          constraints,
          fontcolor: colorerror ?? MainConstant.yellow3,
          fontsize: MainConstant.h14,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return textvaridation;
        }
        return null;
      },
    ),
  );

  // ===> ปุ่ม <=== //
  static Widget mainButton(
    BuildContext context,
    BoxConstraints constraints, {
    VoidCallback? onPressed,
    Widget? child,
    Color? backgroundcolor,
    Color? foregroundcolor,
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      width: width ?? MainConstant.setWidth(context, constraints, 330),
      height: height ?? MainConstant.setHeight(context, constraints, 40),
      margin:
          margin ??
          EdgeInsets.only(
            top: MainConstant.setHeight(context, constraints, 17),
            bottom: MainConstant.setHeight(context, constraints, 10),
          ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundcolor ?? MainConstant.grey26,
          foregroundColor: foregroundcolor ?? MainConstant.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MainConstant.setWidth(context, constraints, 36)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MainConstant.setWidth(context, constraints, 4),
            vertical: MainConstant.setHeight(context, constraints, 4),
          ),
        ),
        child:
            child ??
            MainUtil.mainText(
              context,
              constraints,
              textstyle: MainUtil.mainTextStyle(
                context,
                constraints,
                fontsize: MainConstant.h18,
                fontweight: MainConstant.boldfontweight,
                fontcolor: foregroundcolor ?? MainConstant.white,
              ),
            ),
      ),
    );
  }
}
