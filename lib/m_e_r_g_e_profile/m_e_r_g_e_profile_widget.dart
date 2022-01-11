import '../auth/auth_util.dart';
import '../backend/backend.dart';
import '../backend/firebase_storage/storage.dart';
import '../edit_model_profile/edit_model_profile_widget.dart';
import '../flutter_flow/flutter_flow_icon_button.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/upload_media.dart';
import '../login/login_widget.dart';
import '../v_i_e_w_producer/v_i_e_w_producer_widget.dart';
import '../custom_code/actions/index.dart' as actions;
import '../flutter_flow/custom_functions.dart' as functions;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class MERGEProfileWidget extends StatefulWidget {
  const MERGEProfileWidget({Key key}) : super(key: key);

  @override
  _MERGEProfileWidgetState createState() => _MERGEProfileWidgetState();
}

class _MERGEProfileWidgetState extends State<MERGEProfileWidget> {
  String uploadedFileUrl = '';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool captureOK2;
  bool captureOK;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(currentUserReference),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: SpinKitThreeBounce(
                color: FlutterFlowTheme.primaryColor,
                size: 50,
              ),
            ),
          );
        }
        final mERGEProfileUsersRecord = snapshot.data;
        return Scaffold(
          key: scaffoldKey,
          floatingActionButton: StreamBuilder<List<TalentPorfolioRecord>>(
            stream: queryTalentPorfolioRecord(
              queryBuilder: (talentPorfolioRecord) =>
                  talentPorfolioRecord.where('userTalent',
                      isEqualTo: mERGEProfileUsersRecord.reference),
              singleRecord: true,
            ),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: SpinKitThreeBounce(
                      color: FlutterFlowTheme.primaryColor,
                      size: 50,
                    ),
                  ),
                );
              }
              List<TalentPorfolioRecord> btnAddPhotoTalentPorfolioRecordList =
                  snapshot.data;
              final btnAddPhotoTalentPorfolioRecord =
                  btnAddPhotoTalentPorfolioRecordList.isNotEmpty
                      ? btnAddPhotoTalentPorfolioRecordList.first
                      : null;
              return FloatingActionButton.extended(
                onPressed: () async {
                  final selectedMedia = await selectMediaWithSourceBottomSheet(
                    context: context,
                    maxWidth: 1024.00,
                    maxHeight: 1024.00,
                    allowPhoto: true,
                  );
                  if (selectedMedia != null &&
                      validateFileFormat(selectedMedia.storagePath, context)) {
                    showUploadMessage(context, 'Uploading file...',
                        showLoading: true);
                    final downloadUrl = await uploadData(
                        selectedMedia.storagePath, selectedMedia.bytes);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    if (downloadUrl != null) {
                      setState(() => uploadedFileUrl = downloadUrl);
                      showUploadMessage(context, 'Success!');
                    } else {
                      showUploadMessage(context, 'Failed to upload media');
                      return;
                    }
                  }
                },
                backgroundColor: FlutterFlowTheme.primaryColor,
                icon: Icon(
                  Icons.add_rounded,
                  color: FlutterFlowTheme.tertiaryColor,
                  size: 24,
                ),
                elevation: 8,
                label: Text(
                  'Add Photo',
                  style: FlutterFlowTheme.bodyText1.override(
                    fontFamily: 'Lexend Deca',
                    color: FlutterFlowTheme.tertiaryColor,
                  ),
                ),
              );
            },
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                if ((mERGEProfileUsersRecord.profileType) == 'Model')
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 170,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.darkText,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24, 0, 0, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 40, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 24, 0),
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                          .dark500,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color: FlutterFlowTheme
                                                            .dark400,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          Colors.transparent,
                                                      borderRadius: 30,
                                                      buttonSize: 46,
                                                      icon: Icon(
                                                        Icons.login_outlined,
                                                        color: FlutterFlowTheme
                                                            .grayIcon400,
                                                        size: 16,
                                                      ),
                                                      onPressed: () async {
                                                        await signOut();
                                                        await Navigator
                                                            .pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                LoginWidget(),
                                                          ),
                                                          (r) => false,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 24, 0),
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                          .dark500,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color: FlutterFlowTheme
                                                            .dark400,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          Colors.transparent,
                                                      borderRadius: 30,
                                                      buttonSize: 46,
                                                      icon: Icon(
                                                        Icons.ios_share,
                                                        color: FlutterFlowTheme
                                                            .tertiaryColor,
                                                        size: 20,
                                                      ),
                                                      onPressed: () async {
                                                        captureOK = await actions
                                                            .captureScreen();
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'error de plataforma',
                                                              style:
                                                                  TextStyle(),
                                                            ),
                                                            duration: Duration(
                                                                milliseconds:
                                                                    4000),
                                                            backgroundColor:
                                                                Color(
                                                                    0x00000000),
                                                          ),
                                                        );

                                                        setState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 24, 0),
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                          .dark500,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color: FlutterFlowTheme
                                                            .dark400,
                                                        width: 1,
                                                      ),
                                                    ),
                                                    child:
                                                        FlutterFlowIconButton(
                                                      borderColor:
                                                          Colors.transparent,
                                                      borderRadius: 30,
                                                      buttonSize: 46,
                                                      icon: Icon(
                                                        Icons.edit_outlined,
                                                        color: FlutterFlowTheme
                                                            .tertiaryColor,
                                                        size: 20,
                                                      ),
                                                      onPressed: () async {
                                                        await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditModelProfileWidget(
                                                              userProfile:
                                                                  mERGEProfileUsersRecord
                                                                      .reference,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  mERGEProfileUsersRecord
                                                      .photoUrl,
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(12, 0, 0, 0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 8, 0, 0),
                                                        child: AutoSizeText(
                                                          mERGEProfileUsersRecord
                                                              .displayName,
                                                          style:
                                                              FlutterFlowTheme
                                                                  .subtitle1
                                                                  .override(
                                                            fontFamily:
                                                                'Lexend Deca',
                                                            color: FlutterFlowTheme
                                                                .tertiaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 8, 0, 0),
                                                        child: Text(
                                                          functions
                                                              .getModelMeasuresStr(
                                                                  mERGEProfileUsersRecord),
                                                          style:
                                                              FlutterFlowTheme
                                                                  .bodyText1
                                                                  .override(
                                                            fontFamily:
                                                                'Lexend Deca',
                                                            color:
                                                                FlutterFlowTheme
                                                                    .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 12, 0, 8),
                                        child: Text(
                                          'Short Description',
                                          style: FlutterFlowTheme.bodyText2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  24, 0, 24, 0),
                                          child: Text(
                                            mERGEProfileUsersRecord.bio,
                                            style: FlutterFlowTheme.bodyText1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24, 0, 24, 0),
                                      child: Text(
                                        mERGEProfileUsersRecord.profileType,
                                        style: FlutterFlowTheme.bodyText1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 12, 0, 8),
                                    child: Text(
                                      'Hair Color',
                                      style: FlutterFlowTheme.bodyText2,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24, 0, 24, 0),
                                      child: Text(
                                        mERGEProfileUsersRecord.modelHairColor,
                                        style: FlutterFlowTheme.bodyText1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 12, 0, 8),
                                    child: Text(
                                      'Eyes Color',
                                      style: FlutterFlowTheme.bodyText2,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24, 0, 24, 0),
                                      child: Text(
                                        mERGEProfileUsersRecord.modelEyesColor,
                                        style: FlutterFlowTheme.bodyText1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 12, 0, 8),
                                        child: Text(
                                          'Company Profile',
                                          style: FlutterFlowTheme.bodyText2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'Hello World',
                                        style: FlutterFlowTheme.bodyText1,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16, 4, 16, 0),
                                    child: InkWell(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VIEWProducerWidget(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.tertiaryColor,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 2,
                                              color: Color(0x3E000000),
                                              offset: Offset(0, 1),
                                            )
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: FlutterFlowTheme.lineColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: StreamBuilder<
                                            List<TalentPorfolioRecord>>(
                                          stream: queryTalentPorfolioRecord(
                                            queryBuilder: (talentPorfolioRecord) =>
                                                talentPorfolioRecord.where(
                                                    'userTalent',
                                                    isEqualTo:
                                                        mERGEProfileUsersRecord
                                                            .reference),
                                            singleRecord: true,
                                          ),
                                          builder: (context, snapshot) {
                                            // Customize what your widget looks like when it's loading.
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: SpinKitThreeBounce(
                                                    color: FlutterFlowTheme
                                                        .primaryColor,
                                                    size: 50,
                                                  ),
                                                ),
                                              );
                                            }
                                            List<TalentPorfolioRecord>
                                                gridViewTalentPorfolioRecordList =
                                                snapshot.data;
                                            // Return an empty Container when the document does not exist.
                                            if (snapshot.data.isEmpty) {
                                              return Container();
                                            }
                                            final gridViewTalentPorfolioRecord =
                                                gridViewTalentPorfolioRecordList
                                                        .isNotEmpty
                                                    ? gridViewTalentPorfolioRecordList
                                                        .first
                                                    : null;
                                            return Builder(
                                              builder: (context) {
                                                final portfolioChildren =
                                                    gridViewTalentPorfolioRecord
                                                            .portfolioURLs
                                                            .toList()
                                                            ?.toList() ??
                                                        [];
                                                return GridView.builder(
                                                  padding: EdgeInsets.zero,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    crossAxisSpacing: 10,
                                                    mainAxisSpacing: 10,
                                                    childAspectRatio: 1,
                                                  ),
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemCount:
                                                      portfolioChildren.length,
                                                  itemBuilder: (context,
                                                      portfolioChildrenIndex) {
                                                    final portfolioChildrenItem =
                                                        portfolioChildren[
                                                            portfolioChildrenIndex];
                                                    return Image.network(
                                                      portfolioChildrenItem,
                                                      width: 100,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 330,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.darkText,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 0, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 40, 0, 0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 24, 0),
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme
                                                        .dark500,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: FlutterFlowTheme
                                                          .dark400,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: FlutterFlowIconButton(
                                                    borderColor:
                                                        Colors.transparent,
                                                    borderRadius: 30,
                                                    buttonSize: 46,
                                                    icon: Icon(
                                                      Icons.login_outlined,
                                                      color: FlutterFlowTheme
                                                          .grayIcon400,
                                                      size: 16,
                                                    ),
                                                    onPressed: () async {
                                                      await signOut();
                                                      await Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginWidget(),
                                                        ),
                                                        (r) => false,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 24, 0),
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme
                                                        .dark500,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: FlutterFlowTheme
                                                          .dark400,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: FlutterFlowIconButton(
                                                    borderColor:
                                                        Colors.transparent,
                                                    borderRadius: 30,
                                                    buttonSize: 46,
                                                    icon: Icon(
                                                      Icons.ios_share,
                                                      color: FlutterFlowTheme
                                                          .tertiaryColor,
                                                      size: 20,
                                                    ),
                                                    onPressed: () async {
                                                      captureOK2 = await actions
                                                          .captureScreen();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'error de plataforma',
                                                            style: TextStyle(),
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  4000),
                                                          backgroundColor:
                                                              Color(0x00000000),
                                                        ),
                                                      );

                                                      setState(() {});
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 24, 0),
                                                child: Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme
                                                        .dark500,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      color: FlutterFlowTheme
                                                          .dark400,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: FlutterFlowIconButton(
                                                    borderColor:
                                                        Colors.transparent,
                                                    borderRadius: 30,
                                                    buttonSize: 46,
                                                    icon: Icon(
                                                      Icons.edit_outlined,
                                                      color: FlutterFlowTheme
                                                          .tertiaryColor,
                                                      size: 20,
                                                    ),
                                                    onPressed: () async {
                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditModelProfileWidget(
                                                            userProfile:
                                                                mERGEProfileUsersRecord
                                                                    .reference,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 5, 24, 0),
                                          child: Image.network(
                                            'https://picsum.photos/seed/862/600',
                                            width: double.infinity,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                mERGEProfileUsersRecord
                                                    .photoUrl,
                                                width: 70,
                                                height: 70,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(12, 0, 0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 8, 0, 0),
                                                      child: AutoSizeText(
                                                        mERGEProfileUsersRecord
                                                            .prodCompanyName,
                                                        style: FlutterFlowTheme
                                                            .subtitle1
                                                            .override(
                                                          fontFamily:
                                                              'Lexend Deca',
                                                          color: FlutterFlowTheme
                                                              .tertiaryColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 8, 0, 0),
                                                      child: Text(
                                                        mERGEProfileUsersRecord
                                                            .displayName,
                                                        style: FlutterFlowTheme
                                                            .bodyText1
                                                            .override(
                                                          fontFamily:
                                                              'Lexend Deca',
                                                          color:
                                                              FlutterFlowTheme
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24, 12, 0, 8),
                                      child: Text(
                                        'Short Description',
                                        style: FlutterFlowTheme.bodyText2,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        child: Text(
                                          mERGEProfileUsersRecord.bio,
                                          style: FlutterFlowTheme.bodyText1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 12, 0, 8),
                                  child: Text(
                                    'Phone Number',
                                    style: FlutterFlowTheme.bodyText2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 0, 24, 0),
                                    child: Text(
                                      mERGEProfileUsersRecord.phoneNumber,
                                      style: FlutterFlowTheme.bodyText1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24, 12, 0, 8),
                                  child: Text(
                                    'Facebook',
                                    style: FlutterFlowTheme.bodyText2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24, 0, 24, 0),
                                    child: Text(
                                      mERGEProfileUsersRecord.profileFacebook,
                                      style: FlutterFlowTheme.bodyText1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24, 12, 0, 8),
                                      child: Text(
                                        'Instagram',
                                        style: FlutterFlowTheme.bodyText2,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24, 0, 24, 0),
                                        child: Text(
                                          mERGEProfileUsersRecord
                                              .profileInstagram,
                                          style: FlutterFlowTheme.bodyText1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24, 12, 0, 8),
                                      child: Text(
                                        'Producer Events',
                                        style: FlutterFlowTheme.bodyText2,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 4, 16, 0),
                                  child: InkWell(
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VIEWProducerWidget(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.tertiaryColor,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 2,
                                            color: Color(0x3E000000),
                                            offset: Offset(0, 1),
                                          )
                                        ],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: FlutterFlowTheme.lineColor,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
