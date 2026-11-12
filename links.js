// PDF의 외부 링크 위치 (extract_links.py 생성)
const PAGE_LINKS = {
  "ch2": {
    "30": [
      {
        "url": "https://facebook.com/ads/library",
        "x": 9.1667,
        "y": 52.7926,
        "width": 14.6307,
        "height": 2.6508
      },
      {
        "url": "https://ads.tiktok.com/business/creativecenter",
        "x": 53.9583,
        "y": 52.7926,
        "width": 22.557,
        "height": 2.6508
      },
      {
        "url": "https://tvcf.co.kr",
        "x": 9.1667,
        "y": 87.2371,
        "width": 5.3007,
        "height": 2.6508
      },
      {
        "url": "https://instagram.com/p/DRelZ4OD9E2",
        "x": 53.9583,
        "y": 87.2371,
        "width": 18.2582,
        "height": 2.6508
      }
    ],
    "48": [
      {
        "url": "https://gemini.google.com/share/64d90a8c90ec",
        "x": 6.25,
        "y": 92.7926,
        "width": 23.7606,
        "height": 2.6508
      },
      {
        "url": "https://gemini.google.com/share/3e774b18f3a6",
        "x": 51.0417,
        "y": 92.7926,
        "width": 23.2141,
        "height": 2.6508
      }
    ],
    "57": [
      {
        "url": "https://gemini.google.com/share/ace863881fab",
        "x": 9.1667,
        "y": 61.3201,
        "width": 25.0982,
        "height": 2.8717
      },
      {
        "url": "https://gemini.google.com/share/4d53b47f4971",
        "x": 53.9583,
        "y": 61.3201,
        "width": 25.2633,
        "height": 2.8717
      }
    ],
    "58": [
      {
        "url": "https://gemini.google.com/share/2f6e95d2c607",
        "x": 9.1667,
        "y": 67.8016,
        "width": 25.3734,
        "height": 2.8717
      },
      {
        "url": "https://gemini.google.com/share/b267dc396858",
        "x": 53.9583,
        "y": 67.8016,
        "width": 25.7886,
        "height": 2.8717
      }
    ],
    "82": [
      {
        "url": "https://instagram.com/p/DSg6qJLgQcU",
        "x": 14.7237,
        "y": 90.209,
        "width": 20.0332,
        "height": 2.8717
      }
    ],
    "91": [
      {
        "url": "https://www.miricanvas.com/ko",
        "x": 8.8542,
        "y": 37.1056,
        "width": 8.1,
        "height": 3.9762
      },
      {
        "url": "https://www.canva.com/ko_kr/",
        "x": 38.5417,
        "y": 37.1056,
        "width": 5.5598,
        "height": 3.9762
      },
      {
        "url": "https://vcat.ai/",
        "x": 68.2292,
        "y": 37.1056,
        "width": 4.86,
        "height": 3.9762
      }
    ],
    "94": [
      {
        "url": "https://www.codenbutter.com/blog/%EC%84%B1%EA%B3%B5%EC%A0%81%EC%9D%B8-%EB%A9%94%ED%83%80-ab%ED%85%8C%EC%8A%A4%ED%8A%B8%EC%9D%98-%EC%A1%B0%EA%B1%B4/",
        "x": 95.9375,
        "y": 90.5556,
        "width": 2.6562,
        "height": 3.2407
      },
      {
        "url": "https://brunch.co.kr/@groobee/52",
        "x": 84.2301,
        "y": 95.8437,
        "width": 14.4397,
        "height": 2.5404
      }
    ],
    "108": [
      {
        "url": "https://www.miricanvas.com/ko",
        "x": 8.8542,
        "y": 76.3469,
        "width": 7.2,
        "height": 3.5344
      }
    ]
  },
  "ch3": {
    "19": [
      {
        "url": "https://wadiz.io/web/campaign/detail/419723",
        "x": 77.3153,
        "y": 94.9222,
        "width": 21.8765,
        "height": 2.6508
      }
    ],
    "27": [
      {
        "url": "https://www.instagram.com/p/DfMSTBkmvBB/?img_index=1",
        "x": 42.1875,
        "y": 90.5556,
        "width": 15.625,
        "height": 3.3333
      }
    ],
    "29": [
      {
        "url": "https://wadiz.io/web/campaign/detail/419975",
        "x": 76.9417,
        "y": 95.5704,
        "width": 21.414,
        "height": 2.6508
      }
    ]
  },
  "ch4": {
    "59": [
      {
        "url": "https://support.google.com/analytics/answer/9756891?hl=ko",
        "x": 82.7604,
        "y": 93.8889,
        "width": 10.9896,
        "height": 2.6852
      }
    ],
    "60": [
      {
        "url": "https://support.google.com/analytics/answer/9756891?hl=ko",
        "x": 82.7604,
        "y": 87.7778,
        "width": 10.9896,
        "height": 2.6852
      }
    ],
    "69": [
      {
        "url": "https://ga-dev-tools.google/campaign-url-builder/",
        "x": 82.4479,
        "y": 89.7222,
        "width": 11.3021,
        "height": 2.6852
      }
    ],
    "73": [
      {
        "url": "https://analytics.google.com/analytics/web/?utm_source=demoaccount&utm_medium=demoaccount&utm_campaign=demoaccount#/a54516992p213025502/reports/intelligenthome",
        "x": 9.375,
        "y": 35.2778,
        "width": 36.5104,
        "height": 4.6296
      },
      {
        "url": "https://shop.merch.google/?srsltid=AYCX9vKwQpaQL1ZmJVHSyRDzF2iNkP3upq2ph7Jpy9WHF8cPm55CKOji",
        "x": 64.8958,
        "y": 36.2963,
        "width": 26.7708,
        "height": 3.3333
      }
    ],
    "77": [
      {
        "url": "https://www.facebook.com/business/help/1438417719786914",
        "x": 6.25,
        "y": 6.6306,
        "width": 23.2016,
        "height": 5.9644
      }
    ]
  }
};
