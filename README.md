# SpeechToTextDemo
The Protocol Buffer toolchain and Cocoapods have some problems
that make manual intervention required to build this example.

To fix them perform the following steps:

1) comment out this line:

#import "transformations/GRXMappingWriter.h"

from gRPC-RxLibrary-umbrella.h. You'll see it when
you build and get an error saying "include of non-modular
header inside framework module."

2) replace any of the following failing import statements:

#import "google/cloud/speech/v1beta1/CloudSpeech.pbobjc.h"
#import "google/api/Annotations.pbobjc.h"
#import "google/longrunning/Operations.pbobjc.h"
#import "google/rpc/Status.pbobjc.h"
#import "google/protobuf/Duration.pbobjc.h"

with the corresponding imports:

#import <googleapis/CloudSpeech.pbobjc.h>
#import <googleapis/Annotations.pbobjc.h>
#import <googleapis/Operations.pbobjc.h>
#import <googleapis/Status.pbobjc.h>
#import <googleapis/Duration.pbobjc.h>
