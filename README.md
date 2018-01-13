# Generative Design

## Ideas
- NASA API von Meteoriten auf einer 3D Erde platzieren und animieren
- Sonnensystem mit physikalischen Formeln gestalten
- Interaktion mit der Kinect und Planeten/ Sterne durch physikalische Formel

Ich habe mich entschieden die letzte Idee umzusetzen.

## Konzeptioneller Ansatz

## Technische Umsetzung

## Gestaltungsmittel

## Realisierung

## Entwicklungprozess

## Bibliotheken & Tools
```
import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;
import org.openkinect.processing.*;
```
Mithilfe dieser Bilbiotheken wird eine Verbindung zur per USB-angeschlossenen Kinect aufzubauen.

Mit `Kinect2 kinect = new Kinect2(this);` wird dann ein Objekt erzeugt, mit dem man dann auf den Datenstrom der Kinect zugreifen kann.
```
kinect2.initVideo(); // bekommt die RGB Videostream der Kinect
kinect2.initDepth(); // die Tiefen
kinect2.initIR(); // Infrarot
kinect2.initRegistered(); // Registered

kinect2.initDevice(); // Datenübertragung starten
```