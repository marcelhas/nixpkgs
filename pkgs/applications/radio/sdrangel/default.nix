{ lib
, stdenv
, airspy
, airspyhf
, aptdec
, boost
, cm256cc
, cmake
, codec2
, dab_lib
, dsdcc
, faad2
, fetchFromGitHub
, fftwFloat
, glew
, hackrf
, hidapi
, ffmpeg
, libiio
, libopus
, libpulseaudio
, libusb1
, limesuite
, libbladeRF
, mbelib
, mkDerivation
, ocl-icd
, opencv3
, pkg-config
, qtcharts
, qtlocation
, qtmultimedia
, qtserialport
, qtspeech
, qtwebsockets
, qtwebengine
, rtl-sdr
, serialdv
, sgp4
, soapysdr-with-plugins
, uhd
}:

mkDerivation rec {
  pname = "sdrangel";
  version = "7.10.0";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "sdrangel";
    rev = "v${version}";
    sha256 = "sha256-hsYt7zGG6CSWeQ9A3GPt65efjZGPu33O5pIhnZjFgmY=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    airspy
    airspyhf
    aptdec
    boost
    cm256cc
    codec2
    dab_lib
    dsdcc
    faad2
    ffmpeg
    fftwFloat
    glew
    hackrf
    hidapi
    libbladeRF
    libiio
    libopus
    libpulseaudio
    libusb1
    limesuite
    mbelib
    opencv3
    qtcharts
    qtlocation
    qtmultimedia
    qtserialport
    qtspeech
    qtwebsockets
    qtwebengine
    rtl-sdr
    serialdv
    sgp4
    soapysdr-with-plugins
    uhd
  ];

  cmakeFlags = [
    "-DAPT_DIR=${aptdec}"
    "-DDAB_LIB=${dab_lib}"
    "-DLIBSERIALDV_INCLUDE_DIR:PATH=${serialdv}/include/serialdv"
    "-DLIMESUITE_INCLUDE_DIR:PATH=${limesuite}/include"
    "-DLIMESUITE_LIBRARY:FILEPATH=${limesuite}/lib/libLimeSuite${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DSGP4_DIR=${sgp4}"
    "-DSOAPYSDR_DIR=${soapysdr-with-plugins}"
  ];

  LD_LIBRARY_PATH = "${ocl-icd}/lib";

  meta = with lib; {
    description = "Software defined radio (SDR) software";
    longDescription = ''
      SDRangel is an Open Source Qt5 / OpenGL 3.0+ SDR and signal analyzer frontend to various hardware.
    '';
    homepage = "https://github.com/f4exb/sdrangel";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ alkeryn ];
    platforms = platforms.unix;
  };
}
