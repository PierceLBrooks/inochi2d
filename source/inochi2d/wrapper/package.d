module inochi2d.wrapper;

import inochi2d;
import inochi2d.math;
import inochi2d.phys;
import inochi2d.fmt;
import inochi2d.core;
import inochi2d.ver;
import std.string;
import std.conv;

alias TimeFunc = extern(C) double function();

private Puppet[string] puppets;

extern(C) void cInInit(TimeFunc timeFunc) {
    inInit(cast(double function())timeFunc);
}

extern(C) void cInUpdate() {
    inUpdate();
}

extern(C) void cInBeginScene() {
    inBeginScene();
}

extern(C) void cInEndScene() {
    inEndScene();
}

extern(C) void cInDrawScene(float left, float top, float width, float height) {
    inDrawScene(vec4(left, top, width, height));
}

extern(C) void cInSetViewport(int width, int height) {
    inSetViewport(width, height);
}

extern(C) int cInGetViewportWidth() {
    int width, height;
    inGetViewport(width, height);
    return width;
}

extern(C) int cInGetViewportHeight() {
    int width, height;
    inGetViewport(width, height);
    return height;
}

extern(C) void cInSetCameraPosition(float x, float y) {
    inGetCamera().position = vec2(x, y);
}

extern(C) float cInGetCameraPositionX() {
    return inGetCamera().position.x;
}

extern(C) float cInGetCameraPositionY() {
    return inGetCamera().position.y;
}

extern(C) void cInSetCameraScale(float x, float y) {
    inGetCamera().scale = vec2(x, y);
}

extern(C) float cInGetCameraScaleX() {
    return inGetCamera().scale.x;
}

extern(C) float cInGetCameraScaleY() {
    return inGetCamera().scale.y;
}

extern(C) void cInSetCameraRotation(float rotation) {
    inGetCamera().rotation = rotation;
}

extern(C) float cInGetCameraRotation() {
    return inGetCamera().rotation;
}

extern(C) int cInLoadPuppet(const char * path, int index) {
    string name = cast(string)std.string.fromStringz(path);
    if (name ~ to!string(index) in puppets) {
        return -1;
    }
    puppets[name ~ to!string(index)] = inLoadPuppet(name);
    return 0;
}

extern(C) int cInUnloadPuppet(const char * path, int index) {
    string name = cast(string)std.string.fromStringz(path);
    name ~= to!string(index);
    if (name !in puppets) {
        return -1;
    }
    puppets.remove(name);
    return 0;
}

extern(C) int cInPuppetUpdate(const char * path, int index) {
    string name = cast(string)std.string.fromStringz(path);
    name ~= to!string(index);
    if (name !in puppets) {
        return -1;
    }
    puppets[name].update();
    return 0;
}

extern(C) int cInPuppetDraw(const char * path, int index) {
    string name = cast(string)std.string.fromStringz(path);
    name ~= to!string(index);
    if (name !in puppets) {
        return -1;
    }
    puppets[name].draw();
    return 0;
}

extern(C) int cInPuppetSetAnimation(const char * path, int index, const char * animation, int asMain) {
    string name = cast(string)std.string.fromStringz(path);
    name ~= to!string(index);
    if (name !in puppets) {
        return -1;
    }
    puppets[name].player.set(cast(string)std.string.fromStringz(animation), asMain != 0);
    return 0;
}

extern(C) int cInPuppetPlayAnimation(const char * path, int index, const char * animation, int looping, int blend) {
    string name = cast(string)std.string.fromStringz(path);
    name ~= to!string(index);
    if (name !in puppets) {
        return -1;
    }
    puppets[name].player.play(cast(string)std.string.fromStringz(animation), looping != 0, blend != 0);
    return 0;
}

extern(C) int cInPuppetPauseAnimation(const char * path, int index, const char * animation) {
    string name = cast(string)std.string.fromStringz(path);
    name ~= to!string(index);
    if (name !in puppets) {
        return -1;
    }
    puppets[name].player.pause(cast(string)std.string.fromStringz(animation));
    return 0;
}

extern(C) int cInPuppetStopAnimation(const char * path, int index, const char * animation, int immediately) {
    string name = cast(string)std.string.fromStringz(path);
    name ~= to!string(index);
    if (name !in puppets) {
        return -1;
    }
    puppets[name].player.stop(cast(string)std.string.fromStringz(animation), immediately != 0);
    return 0;
}

extern(C) int cInPuppetSeekAnimationFrame(const char * path, int index, const char * animation, float frame) {
    string name = cast(string)std.string.fromStringz(path);
    name ~= to!string(index);
    if (name !in puppets) {
        return -1;
    }
    puppets[name].player.seek(cast(string)std.string.fromStringz(animation), frame);
    return 0;
}


extern(C) float cInPuppetTellAnimationFrame(const char * path, int index, const char * animation) {
    string name = cast(string)std.string.fromStringz(path);
    name ~= to!string(index);
    if (name !in puppets) {
        return 0f;
    }
    return puppets[name].player.tell(cast(string)std.string.fromStringz(animation));
}

