class StoryConstants {
  static const double aspectRatio = 15 / 7;
  static const double spaceBetweenStory = 5;

  static const String backgroundKey = 'story_background';
  static const String storyItemKey = 'story_item';
  static const String textKey = 'storyText_';
  static const String storyTapKey = 'openStoryFullscreenKey_';
  static const String storyKeyButtonClose = 'storyKeyButtonClose';
  static const String keyTextOfCardStory = 'keyTextOfCardStory_';
}

// TODO(Hieu): will remove
const Map storyConfigHomeMock = {
  'layout': 'story',
  'name': 'Stories',
  'active': true,
  'isHorizontal': true,
  'countColumn': 4,
  'radius': 10.0,
  'data': [
    {
      'layout': 1,
      'urlImage':
          'https://firebasestorage.googleapis.com/v0/b/ampstor.appspot.com/o/images%2FOBBjxIsNP6gZib8d3rJVXWq0gAC3%2Fsatelite.png?alt=media&token=ede905ad-509d-468f-b5c3-99d7d4d0a826',
      'contents': [
        {
          'title': 'MARCH 7, 2019',
          'paddingContent': {
            'top': 1.2,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Roboto',
            'fontSize': 15.0,
            'fontStyle': 'normal',
            'align': 'center',
            'transform': 'full'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        },
        {
          'title': 'SpaceXs Crew Dragon approached the space station',
          'paddingContent': {
            'top': 0.2,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Playfair Display',
            'fontSize': 37.0,
            'fontStyle': 'bold',
            'align': 'center',
            'transform': 'normal'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        },
        {
          'title': 'Published by John Doe',
          'paddingContent': {
            'top': 0.1,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Roboto',
            'fontSize': 12.0,
            'fontStyle': 'normal',
            'align': 'center',
            'transform': 'full'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        }
      ]
    },
    {
      'layout': 3,
      'urlImage':
          'https://images.pexels.com/photos/1065753/pexels-photo-1065753.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
      'contents': [
        {
          'title': '5',
          'paddingContent': {
            'top': 0.3,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Oswald',
            'fontSize': 250.0,
            'fontStyle': 'normal',
            'align': 'center',
            'transform': 'full'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        },
        {
          'title': 'Best Places to visit in Switzerland',
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Oswald',
            'fontSize': 35.0,
            'fontStyle': 'normal',
            'align': 'center',
            'transform': 'full'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        },
        {
          'title': 'Updated August 2019',
          'paddingContent': {
            'top': 0.1,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Roboto',
            'fontSize': 12.0,
            'fontStyle': 'normal',
            'align': 'center',
            'transform': 'full'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        }
      ]
    },
    {
      'layout': 1,
      'urlImage':
          'https://images.unsplash.com/photo-1535295972055-1c762f4483e5?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjgwOTU5fQ',
      'contents': [
        {
          'title': 'Shop Custom Made',
          'paddingContent': {
            'top': 0.3,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Lobster',
            'fontSize': 40.0,
            'fontStyle': 'bold',
            'align': 'center',
            'transform': 'full'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        },
        {
          'title': 'Personalized shopping is our newest obsession.',
          'paddingContent': {
            'top': 0.2,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Roboto',
            'fontSize': 15.0,
            'fontStyle': 'normal',
            'align': 'center',
            'transform': 'full'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        }
      ]
    },
    {
      'layout': 4,
      'urlImage':
          'https://firebasestorage.googleapis.com/v0/b/ampstor.appspot.com/o/images%2FOBBjxIsNP6gZib8d3rJVXWq0gAC3%2Fb3.jpeg?alt=media&token=46390320-6538-4932-a52f-18d952bf258b',
      'contents': [
        {
          'title': 'THE\n BAHAMAS',
          'paddingContent': {
            'top': 1.3,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Domine',
            'fontSize': 55.0,
            'fontStyle': 'normal',
            'align': 'center',
            'transform': 'full'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        },
        {
          'title':
              // ignore: lines_longer_than_80_chars
              'A must visit tourist attractions for 2020, as written by Ampstor editors.',
          'paddingContent': {
            'top': 0.1,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Grenze',
            'fontSize': 25.0,
            'fontStyle': 'normal',
            'align': 'center',
            'transform': 'full'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        }
      ]
    },
    {
      'layout': 1,
      'urlImage':
          'https://images.unsplash.com/photo-1535295972055-1c762f4483e5?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjgwOTU5fQ',
      'contents': [
        {
          'title': 'Shop Custom Made',
          'paddingContent': {
            'top': 0.3,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Lobster',
            'fontSize': 40.0,
            'fontStyle': 'bold',
            'align': 'center',
            'transform': 'full'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        },
        {
          'title': 'Personalized shopping is our newest obsession.',
          'paddingContent': {
            'top': 0.2,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Roboto',
            'fontSize': 15.0,
            'fontStyle': 'normal',
            'align': 'center',
            'transform': 'full'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        }
      ]
    },
    {
      'layout': 1,
      'urlImage':
          'https://firebasestorage.googleapis.com/v0/b/ampstor.appspot.com/o/images%2FOBBjxIsNP6gZib8d3rJVXWq0gAC3%2Fsatelite.png?alt=media&token=ede905ad-509d-468f-b5c3-99d7d4d0a826',
      'contents': [
        {
          'title': 'MARCH 7, 2019',
          'paddingContent': {
            'top': 1.2,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Roboto',
            'fontSize': 15.0,
            'fontStyle': 'normal',
            'align': 'center',
            'transform': 'full'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        },
        {
          'title': 'SpaceXs Crew Dragon approached the space station',
          'paddingContent': {
            'top': 0.2,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Playfair Display',
            'fontSize': 37.0,
            'fontStyle': 'bold',
            'align': 'center',
            'transform': 'normal'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        },
        {
          'title': 'Published by John Doe',
          'paddingContent': {
            'top': 0.1,
            'bottom': null,
            'left': null,
            'right': null
          },
          'link': {'url': '', 'type': 'category'},
          'typography': {
            'font': 'Roboto',
            'fontSize': 12.0,
            'fontStyle': 'normal',
            'align': 'center',
            'transform': 'full'
          },
          'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
          'spacing': {
            'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
            'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
          }
        }
      ]
    }
  ]
};

const Map storyConfigMock = {
  'layout': 1,
  'urlImage': 'https://images.unsplash.com/photo-1535704882196-765e5fc62a53',
  'contents': [
    {
      'title': 'MARCH 7, 2019',
      'paddingContent': {
        'top': 0.1,
        'bottom': null,
        'left': null,
        'right': null
      },
      'link': {'type': 'category', 'value': '23', 'tag': '1'},
      'typography': {
        'font': 'Roboto',
        'fontSize': 15.0,
        'fontStyle': 'normal',
        'align': 'center',
        'transform': 'full'
      },
      'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
      'spacing': {
        'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
        'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
      }
    },
    {
      'title': "SpaceX's Crew Dragon approached the space station",
      'paddingContent': {
        'top': 0.2,
        'bottom': null,
        'left': null,
        'right': null
      },
      'link': {'url': '', 'type': 'category'},
      'typography': {
        'font': 'Playfair Display',
        'fontSize': 37.0,
        'fontStyle': 'bold',
        'align': 'center',
        'transform': 'normal'
      },
      'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
      'spacing': {
        'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
        'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
      }
    },
    {
      'title': 'Published by John Doe',
      'paddingContent': {
        'top': 0.1,
        'bottom': null,
        'left': null,
        'right': null
      },
      'link': {'url': '', 'type': 'category'},
      'typography': {
        'font': 'Roboto',
        'fontSize': 12.0,
        'fontStyle': 'normal',
        'align': 'center',
        'transform': 'full'
      },
      'animation': {'type': 'fadeIn', 'milliseconds': 300, 'delay': 0},
      'spacing': {
        'padding': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0},
        'margin': {'left': 0.0, 'right': 0.0, 'top': 0.0, 'bottom': 0.0}
      }
    }
  ]
};
