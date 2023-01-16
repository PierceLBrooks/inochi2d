
#include "inochi2d.h"
#include <SFML/Graphics/Sprite.hpp>
#include <SFML/Graphics/RenderTexture.hpp>
#include <SFML/Graphics/RenderWindow.hpp>
#include <SFML/Window/ContextSettings.hpp>
#include <SFML/Window/Event.hpp>
#include <SFML/System/Clock.hpp>
#include <iostream>
#include <string>

sf::Clock* timer = nullptr;

double getTime()
{
    if (timer == nullptr) {
        timer = new sf::Clock();
        return 0.0f;
    }
    return static_cast<double>(timer->restart().asSeconds());
}

int main(int argc, char** argv)
{
    int width = 1024;
    int height = 1024;
    std::string puppet = "";
    sf::Sprite* puppetSprite = nullptr;
    sf::RenderTexture* puppetTexture = nullptr;
    sf::RenderWindow* window = new sf::RenderWindow();
    window->create(sf::VideoMode(width, height), "Inochi2D");
    window->setFramerateLimit(60);
    while (window->isOpen()) {
        sf::Event event;
        while (window->pollEvent(event)) {
            switch (event.type) {
            case sf::Event::Closed:
                window->close();
                break;
            }
        }
        if (!window->isOpen()) {
            break;
        }
        if (puppetTexture == nullptr) {
            if (argc > 1) {
                puppet += std::string(argv[1]);
                puppetTexture->create(width, height, sf::ContextSettings(0, 1));
                puppetTexture->setActive(true);
                cInInit([](){return getTime();});
                cInSetViewport(width, height);
                width = cInGetViewportWidth();
                height = cInGetViewportHeight();
                std::cout << width << 'x' << height << std::endl;
                cInSetCameraScale(0.5f, 0.5f);
                std::cout << cInLoadPuppet(puppet.c_str(), 0) << std::endl;
                continue;
            }
        } else {
            cInUpdate();
            cInBeginScene();
            cInPuppetUpdate(puppet.c_str(), 0);
            cInPuppetDraw(puppet.c_str(), 0);
            cInEndScene();
            cInDrawScene(0, 0, width, height);
            if (puppetSprite == nullptr) {
                puppetSprite = new sf::Sprite(puppetTexture->getTexture());
                puppetSprite->setPosition(sf::Vector2f(window->getSize())*0.5f);
                puppetSprite->setOrigin(sf::Vector2f(puppetSprite->getTexture()->getSize())*0.5f);
            }
        }
        window->clear(sf::Color::Black);
        if (puppetSprite != nullptr) {
            puppetTexture->display();
            window->setActive(true);
            window->resetGLStates();
            window->draw(*puppetSprite);
        }
        window->display();
    }
    if (!puppet.empty()) {
        cInUnloadPuppet(puppet.c_str(), 0);
    }
    delete puppetSprite;
    delete puppetTexture;
    delete window;
    return 0;
}

